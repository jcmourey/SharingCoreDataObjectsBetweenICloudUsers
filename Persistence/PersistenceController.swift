/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A class that sets up the Core Data stack.
*/

import CoreData
import CloudKit
import SwiftUI

let gCloudKitContainerIdentifier = "iCloud.com.mourey.WeJourney"
let gCoreDataIdentifier = "CloudKitShare"

/**
 This app doesn't necessarily post notifications from the main queue.
 */
extension Notification.Name {
    static let cdcksStoreDidChange = Notification.Name("cdcksStoreDidChange")
}

struct UserInfoKey {
    static let storeUUID = "storeUUID"
    static let transactions = "transactions"
}

struct TransactionAuthor {
    static let app = "app"
}

class PersistenceController {
    static let shared = PersistenceController()
    
    private var persistentStores = [CKDatabase.Scope: NSPersistentStore]()
    
    #if os(iOS)
    let cloudSharingControllerDelegate = UI_CloudSharingControllerDelegate()
    #elseif os(macOS)
    let cloudSharingControllerDelegate = NS_CloudSharingServiceDelegate()
    #endif
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        do {
            let container = try createPersistentContainer()
            Task {
                persistentStores = try await container.loadPersistentStores()
            }
            
            /**
             Run initializeCloudKitSchema() once to update the CloudKit schema every time you change the Core Data model.
             Dispatch to the next runloop in the main queue to avoid blocking AppKit app life-cycle delegate methods.
             Don't call this code in the production environment.
             */
            #if InitializeCloudKitSchema
            DispatchQueue.main.async {
                do {
                    try container.initializeCloudKitSchema()
                } catch {
                    print("\(#function): initializeCloudKitSchema: \(error)")
                }
            }
            #else
            try container.setUpdateStrategy()
            
            /**
             Observe the following notifications:
             - The remote change notifications from container.persistentStoreCoordinator.
             - The event change notifications from the container.
             */
            NotificationCenter.default.addObserver(self, selector: #selector(storeRemoteChange(_:)),
                                                   name: .NSPersistentStoreRemoteChange,
                                                   object: container.persistentStoreCoordinator)
            NotificationCenter.default.addObserver(self, selector: #selector(containerEventChanged(_:)),
                                                   name: NSPersistentCloudKitContainer.eventChangedNotification,
                                                   object: container)
            #endif
                
            return container
            
        } catch {
            fatalError("#\(#function): creating persistence controller: \(error)")
        }
    }()
    
    func createPersistentContainer() throws -> NSPersistentCloudKitContainer {
        /**
         Prepare the containing folder for the Core Data stores.
         A Core Data store has companion files, so it's a good practice to put a store under a folder.
         */
        let baseURL = NSPersistentContainer.defaultDirectoryURL()
        let storeFolderURL = baseURL.appendingPathComponent("CoreDataStores")
        
        let container = NSPersistentCloudKitContainer(name: gCoreDataIdentifier)

        /**
         Grab the default (first) store and associate it with the CloudKit private database.
         Set up the store description by:
         - Specifying a filename for the store.
         - Enabling history tracking and remote notifications.
         - Specifying the iCloud container and database scope.
        */
        guard let privateStoreDescription = container.persistentStoreDescriptions.first else {
            fatalError("#\(#function): Failed to retrieve a persistent store description.")
        }
        try privateStoreDescription.associateAsPrivate(to: gCloudKitContainerIdentifier, in: storeFolderURL)

        /**
         Similarly, add a second store and associate it with the CloudKit shared database.
         */
        guard let sharedStoreDescription = privateStoreDescription.copy() as? NSPersistentStoreDescription else {
            fatalError("#\(#function): Copying the private store description returned an unexpected value.")
        }
        try sharedStoreDescription.associateAsShared(to: gCloudKitContainerIdentifier, in: storeFolderURL)
        
        container.persistentStoreDescriptions.append(sharedStoreDescription)

        return container
    }
    
    var privatePersistentStore: NSPersistentStore {
        return persistentStores[.private]!
    }

    var sharedPersistentStore: NSPersistentStore {
        return persistentStores[.shared]!
    }
    
    lazy var cloudKitContainer: CKContainer = {
        CKContainer(identifier: gCloudKitContainerIdentifier)
    }()
    
    /**
     An operation queue for handling history-processing tasks: watching changes, deduplicating tags, and triggering UI updates, if needed.
     */
    lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

extension NSPersistentStoreDescription {
    func associate(as databaseScope: CKDatabase.Scope, to cloudKitContainerIdentifier: String, in storeFolderURL: URL) throws {
        url = try storeFolderURL
            .appendingPathComponent(databaseScope.stringValue)
            .ensureExists()
            .appendingPathComponent("\(databaseScope.stringValue).sqlite")
        
        cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: cloudKitContainerIdentifier)
        cloudKitContainerOptions?.databaseScope = databaseScope
    }
    
    func associateAsPrivate(to cloudKitContainerIdentifier: String, in storeFolderURL: URL) throws {
        try associate(as: .private, to: cloudKitContainerIdentifier, in: storeFolderURL)
        
        setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
    }
    
    func associateAsShared(to cloudKitContainerIdentifier: String, in storeFolderURL: URL) throws {
        try associate(as: .shared, to: cloudKitContainerIdentifier, in: storeFolderURL)
    }
}

extension NSPersistentContainer {
    func setUpdateStrategy() throws {
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        viewContext.transactionAuthor = TransactionAuthor.app

        /**
         Automatically merge the changes from other contexts.
         */
        viewContext.automaticallyMergesChangesFromParent = true

        /**
         Pin the viewContext to the current generation token and set it to keep itself up-to-date with local changes.
         */
        try viewContext.setQueryGenerationFrom(.current)
    }
    
}
