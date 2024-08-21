//
//  MediumEmployeeManagerTests.swift
//  CoreDataBootcampTests
//
//  Created by Ponthota, Viswanath Reddy on 21/08/24.
//

@testable import CoreDataBootcamp
import XCTest


class MediumEmployeeManagerTests: XCTest {
    var employeeManager: MediumEmployeeManager!
    var coreDataStack: CoreDataTestStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        employeeManager = MediumEmployeeManager(mainContext: coreDataStack.mainContext)
    }
    
    func test_create_employee() {
        employeeManager.createEmployee(firstName: "Jon")
        let employee = employeeManager.fetchEmployee(withName: "Jon")!
        
        XCTAssertEqual("Jon", employee.firstName)
    }
    
    func test_update_employee() {
        let employee = employeeManager.createEmployee(firstName: "Jon")!
        employee.firstName = "viswanath"
        employeeManager.updateEmployee(employee: employee)
        let updated = employeeManager.fetchEmployee(withName: "viswanath")!
        
        XCTAssertNil(employeeManager.fetchEmployee(withName: "Jon"))
        XCTAssertEqual("viswanath", updated.firstName)
    }
    
    func test_delete_employees() {
        let employeeA = employeeManager.createEmployee(firstName: "A")!
        let employeeB = employeeManager.createEmployee(firstName: "B")!
        let employeeC = employeeManager.createEmployee(firstName: "C")!
        
        employeeManager.deleteEmployee(employee: employeeB)
        
        let employees = employeeManager.fetchEmployees()!
        
        XCTAssertEqual(employees.count, 2)
        XCTAssertTrue(employees.contains(employeeA))
        XCTAssertTrue(employees.contains(employeeC))
    }
}
