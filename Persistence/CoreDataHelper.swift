/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Extensions that add convenience methods to Core Data.
*/

import CoreData
import CloudKit

extension NSPersistentStore {
    func contains(manageObject: NSManagedObject) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: manageObject.entity.name!)
        fetchRequest.predicate = NSPredicate(format: "self == %@", manageObject)
        fetchRequest.affectedStores = [self]
        
        if let context = manageObject.managedObjectContext,
           let result = try? context.count(for: fetchRequest), result > 0 {
            return true
        }
        return false
    }
}

extension NSManagedObject {
    var persistentStore: NSPersistentStore? {
        let persistenceController = PersistenceController.shared
        if persistenceController.sharedPersistentStore.contains(manageObject: self) {
            return persistenceController.sharedPersistentStore
        } else if persistenceController.privatePersistentStore.contains(manageObject: self) {
            return persistenceController.privatePersistentStore
        }
        return nil
    }
}

extension NSManagedObjectContext {
    /**
     Contextual information for handling errors that occur when saving a managed object context.
     */
    enum ContextualInfoForSaving: String {
        case addPhoto, deletePhoto
        case toggleTagging, deleteTag, addTag
        case addRating, deleteRating
        case sheetOnDismiss
        case deduplicateAndWait, removeDeduplicatedTags
    }
    /**
     Save a context and handle the save error. This sample simply prints the error message. Real apps can
     implement comprehensive error handling based on the contextual information.
     */
    func save(with contextualInfo: ContextualInfoForSaving) {
        if hasChanges {
            do {
                try save()
            } catch {
                print("\(#function): Failed to save Core Data context for \(contextualInfo.rawValue): \(error)")
            }
        }
    }
}

extension NSPersistentCloudKitContainer {
    /**
     A convenience method for creating background contexts that specify the app as their transaction author.
     */
    func newTaskContext() -> NSManagedObjectContext {
        let context = newBackgroundContext()
        context.transactionAuthor = TransactionAuthor.app
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    /**
     Fetch and return shares in the persistent stores.
     */
    func fetchShares(in persistentStores: [NSPersistentStore]) throws -> [CKShare] {
        var results = [CKShare]()
        for persistentStore in persistentStores {
            do {
                let shares = try fetchShares(in: persistentStore)
                results += shares
            } catch let error {
                print("Failed to fetch shares in \(persistentStore).")
                throw error
            }
        }
        return results
    }
   
    enum Error: Swift.Error {
        case noCloudKitContainerOptions(String)
        case noLoadedStoreDescriptionURL(String)
        case noPersistentStore(URL)
        case noDatabaseScope(String)
    }
    
    /**
     Async version of loadPersistentStores
     */
    func loadPersistentStores() async throws -> [CKDatabase.Scope: NSPersistentStore] {
        try await withCheckedThrowingContinuation { continuation in
            var loadedStores = [CKDatabase.Scope: NSPersistentStore]()
            var errors = [any Swift.Error]()
            
            loadPersistentStores { loadedStoreDescription, error in
                if let error {
                    errors.append(error)
                } else {
                    guard let url = loadedStoreDescription.url else {
                        errors.append(Error.noLoadedStoreDescriptionURL(loadedStoreDescription.type))
                        return
                    }
                    guard let persistentStore = self.persistentStoreCoordinator.persistentStore(for: url) else {
                        errors.append(Error.noPersistentStore(url))
                        return
                    }
                    guard let databaseScope = loadedStoreDescription.cloudKitContainerOptions?.databaseScope else {
                        errors.append(Error.noDatabaseScope(loadedStoreDescription.type))
                        return
                    }
                    loadedStores[databaseScope] = persistentStore
                }
            }
            
            if let error = errors.first {
                continuation.resume(throwing: error)
            } else {
                continuation.resume(returning: loadedStores)
            }
        }
    }
}
