//
//  CoreDataTestStack.swift
//  CoreDataBootcampTests
//
//  Created by Ponthota, Viswanath Reddy on 21/08/24.
//

import Foundation
import CoreData

/*
 This is the CoreDataManager used by tests. It saves nothing to disk. All in-memory.
 
 When setting up tests authors can choose the queues they would like to operate on.
 - `mainContext` with interacts on the main UI thread, or
 - `backgroundContext` with has a separate queue for background processing
 
 Note: This can't be a shared singleton. Else tests would collide with each other.
 */

class CoreDataTestStack {
    let persistenceContainer: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    init() {
        persistenceContainer = NSPersistentContainer(name: "CoreDataBootcamp")
        let description = persistenceContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistenceContainer.loadPersistentStores { description, error in
            guard error == nil else { fatalError("was unable to load store \(error!)") }
        }
        
        mainContext =  NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistenceContainer.persistentStoreCoordinator
        
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = mainContext
    }
}
