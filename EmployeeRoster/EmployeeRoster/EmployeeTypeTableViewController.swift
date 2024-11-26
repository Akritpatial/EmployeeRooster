//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by student-2 on 26/11/24.
//

import UIKit




class EmployeeTypeTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmployeeTypeCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    protocol EmployeeTypeTableViewControllerDelegate: AnyObject {
        func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType)
    }
    
    
    weak var delegate: EmployeeTypeTableViewControllerDelegate?
    
    var employeeType: EmployeeType?
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EmployeeType.allCases.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTypeCell", for: indexPath)
        
        let type = EmployeeType.allCases[indexPath.row]
        
        
        var content = cell.defaultContentConfiguration()
        
        content.text = type.description
        
        cell.contentConfiguration = content
        
        cell.accessoryType = (employeeType == type) ? .checkmark : .none
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        employeeType = EmployeeType.allCases[indexPath.row]
        
        delegate?.employeeTypeTableViewController(self, didSelect: employeeType!)
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
