//
//  CoreDataStack.swift
//  CoreDataBootcamp
//
//  Created by Ponthota, Viswanath Reddy on 21/08/24.
//

import Foundation
import CoreData


/*
 This is the CoreDataManager used by the app. It saves changes to disk.

 Managers can do operations via the:
 - `mainContext` with interacts on the main UI thread, or
 - `backgroundContext` with has a separate queue for background processing

 */

class CoreDataStack {
    static let shared = CoreDataStack()
    
    let persistenceContainer: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    private init() {
        persistenceContainer = NSPersistentContainer(name: "CoreDataBootcamp")
        let description = persistenceContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        
        persistenceContainer.loadPersistentStores { description, error in
            guard error == nil else { fatalError("was unable to load store \(error!)") }
        }
        
        mainContext = persistenceContainer.viewContext
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = mainContext
    }
}
