//
//  ProductDataManager.swift
//  CoreDataBootcamp
//
//  Created by Ponthota, Viswanath Reddy on 21/08/24.
//

import UIKit
import CoreData

/*
 This more complex implementation does everything on the background thread.
 More performant. But also more complex and risky.
 */
class ComplexEmployeeManager {
 
    // MARK: Contexts
    
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    /*
     Note: All fetches should always be done on mainContext. Updates, creates, deletes can be background.
     Contexts are passed in so they can be overridden via unit testing.
     */
    
    // MARK: - Init
    
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext,
         backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }
    
    // MARK: - Create
    
    func createEmployee(firstName: String) {
        backgroundContext.performAndWait {
            let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: backgroundContext) as! Employee
            employee.firstName = firstName
            
            try? backgroundContext.save()
        }
    }
    
    // MARK: - Deletion
    
    func deleteEmployee(employee: Employee) {
        let objectID = employee.objectID
        backgroundContext.performAndWait {
            if let employeeInContext = try? backgroundContext.existingObject(with: objectID) {
                backgroundContext.delete(employeeInContext)
                try? backgroundContext.save()
            }
        }
    }
        
    // MARK: - Update
    
    func updateEmployee(employee: Employee) {
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
            } catch let error {
                print("Failed to update: \(error)")
            }
        }
    }
    
    // MARK: - Fetch
    
    /*
     Rule: Managed objects retrieved from a context are bound to the same queue that the context is bound to.
     
     So if we want the results of our fetches to be used in the UI, we should do those fetching
     from the main UI context.
     
     */
    func fetchEmployee(withName name: String) -> Employee? {
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "firstName == %@", name)
        
        var employee: Employee?
        
        mainContext.performAndWait {
            do {
                let employees = try mainContext.fetch(fetchRequest)
                employee = employees.first
            } catch let error {
                print("Failed to fetch: \(error)")
            }
        }
        
        return employee
    }

    func fetchEmployees() -> [Employee]? {
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
        var employees: [Employee]?
        
        mainContext.performAndWait {
            do {
                employees = try mainContext.fetch(fetchRequest)
            } catch let error {
                print("Failed to fetch companies: \(error)")
            }
        }
        
        return employees
    }
}
