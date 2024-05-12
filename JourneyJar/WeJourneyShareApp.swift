/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The SwiftUI app for iOS.
*/

import SwiftUI
import CoreData

@main
struct WeJourneyShareApp: App {
    @ApplicationDelegateAdaptor var appDelegate: AppDelegate

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        #if InitializeCloudKitSchema
        WindowGroup {
            Text("Initializing CloudKit Schema...").font(.title)
            Text("Stop after Xcode says 'no more requests to execute', " +
                 "then check with CloudKit Console if the schema is created correctly.").padding()
        }
        #else
        WindowGroup {
            PhotoGridView()
                .environment(\.managedObjectContext, persistenceController.persistentContainer.viewContext)
        }
        #endif
    }
}

