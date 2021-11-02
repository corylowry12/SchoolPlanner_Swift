//
//  AssignmentSettingsViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 11/2/21.
//

import Foundation
import UIKit

class AssignmentSettingsViewController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let indexPath = IndexPath(row: userDefaults.integer(forKey: "categoryBackground"), section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        
        let indexPathCategory = IndexPath(row: userDefaults.integer(forKey: "defaultCategory"), section: 1)
        tableView.selectRow(at: indexPathCategory, animated: false, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPathCategory)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDefaults = UserDefaults.standard
        if indexPath.section == 0 {
            tableView.cellForRow(at: [0, userDefaults.integer(forKey: "categoryBackground")])?.accessoryType = .none
          
        userDefaults.set(indexPath.row, forKey: "categoryBackground")
            tableView.cellForRow(at: [0, userDefaults.integer(forKey: "categoryBackground")])?.accessoryType = .checkmark
        }
        else if indexPath.section == 1 {
            tableView.cellForRow(at: [1, userDefaults.integer(forKey: "defaultCategory")])?.accessoryType = .none
          
        userDefaults.set(indexPath.row, forKey: "defaultCategory")
            tableView.cellForRow(at: [1, userDefaults.integer(forKey: "defaultCategory")])?.accessoryType = .checkmark
        }
    }
}
