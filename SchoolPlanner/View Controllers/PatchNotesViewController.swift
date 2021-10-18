//
//  PatchNotesViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/22/21.
//

import Foundation
import UIKit

class PatchNotesViewController: UITableViewController {
    
    override func viewDidLoad() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let userDefaults = UserDefaults.standard
        userDefaults.set(appVersion, forKey: "appVersion")
        tabBarController?.tabBar.items?[2].badgeValue = nil
    }
}
