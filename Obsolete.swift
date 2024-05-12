//
//  Obsolete.swift
//  WeJourney
//
//  Created by Jean-Charles Mourey on 11/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

//import Foundation
//
//container.loadPersistentStores { loadedStoreDescription, error in
//    if let error {
//        fatalError("#\(#function): Failed to load persistent stores:\(error)")
//    }
//    guard let cloudKitContainerOptions = loadedStoreDescription.cloudKitContainerOptions else {
//        let error = NSPersistentCloudKitContainer.Error.noCloudKitContainerOptions(loadedStoreDescription.type)
//        fatalError("#\(#function): \(error)")
//    }
//    guard let url = loadedStoreDescription.url else {
//        let error = NSPersistentCloudKitContainer.Error.noLoadedStoreDescriptionURL(loadedStoreDescription.type)
//        fatalError("#\(#function): \(error)")
//    }
//    guard let persistentStore = container.persistentStoreCoordinator.persistentStore(for: url) else {
//        let error = NSPersistentCloudKitContainer.Error.noPersistentStore(url)
//        fatalError("#\(#function): \(error)")
//    }
//    guard let databaseScope = loadedStoreDescription.cloudKitContainerOptions?.databaseScope else {
//        let error = NSPersistentCloudKitContainer.Error.noDatabaseScope(loadedStoreDescription.type)
//        fatalError("#\(#function): \(error)")
//    }
//    persistentStores[databaseScope] = persistentStore
//}
