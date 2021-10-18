//
//  AppearanceViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/21/21.
//

import Foundation
import UIKit

class AppearanceViewController: UITableViewController {
    
    @IBOutlet var themeTableView: UITableView!
    
    let storedThemeValue = UserDefaults.standard.integer(forKey: "theme")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indexPath = IndexPath(row: storedThemeValue, section: 0)
        themeTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        themeTableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            let userDefaults = UserDefaults.standard
            
            if indexPath.row == 0 {
                tableView.cellForRow(at: [0, userDefaults.integer(forKey: "theme")])?.accessoryType = .none
              
                UIView.transition(with: view.window ?? UIWindow(), duration: 0.5, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {
                    self.view.window?.overrideUserInterfaceStyle = .light
                }, completion: nil)
                userDefaults.set(0, forKey: "theme")
                themeTableView.cellForRow(at: [0, userDefaults.integer(forKey: "theme")])?.accessoryType = .checkmark
            }
            else if indexPath.row == 1 {
                tableView.cellForRow(at: [0, userDefaults.integer(forKey: "theme")])?.accessoryType = .none
                UIView.transition(with: view.window ?? UIWindow(), duration: 0.5, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {
                    self.view.window?.overrideUserInterfaceStyle = .dark
                }, completion: nil)
                userDefaults.set(1, forKey: "theme")
                themeTableView.cellForRow(at: [0, userDefaults.integer(forKey: "theme")])?.accessoryType = .checkmark
            }
            else if indexPath.row == 2 {
                tableView.cellForRow(at: [0, userDefaults.integer(forKey: "theme")])?.accessoryType = .none
                UIView.transition(with: view.window ?? UIWindow(), duration: 0.5, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {
                    self.view.window?.overrideUserInterfaceStyle = .unspecified
                }, completion: nil)
                userDefaults.set(2, forKey: "theme")
                themeTableView.cellForRow(at: [0, userDefaults.integer(forKey: "theme")])?.accessoryType = .checkmark
            }
        }
    }
}
