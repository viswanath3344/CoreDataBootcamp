//
//  ViewController.swift
//  CoreDataBootcamp
//
//  Created by Ponthota, Viswanath Reddy (Cognizant) on 21/08/24.
//

import UIKit

class ViewController: UIViewController {
    
    let manager = SimpleEmployeeManager()
    //    let manager = MediumEmployeeManager()
    //    let manager = ComplexEmployeeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        manager.createEmployee(firstName: "Jon")
        let jon = manager.fetchEmployee(withName: "Jon")!
        
        manager.updateEmployee(employee: jon)
        manager.deleteEmployee(employee: jon)
    }
    
    
}

