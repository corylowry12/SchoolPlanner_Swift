//
//  SettingsTableViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/23/21.
//

import Foundation
import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet weak var patchNotesCell: UITableViewCell!
    let userDefaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        if userDefaults.value(forKey: "appVersion") == nil || userDefaults.value(forKey: "appVersion") as? String != appVersion {
            let size: CGFloat = 22
            let width = max(size, 0.7 * size * 1) // perfect circle is smallest allowed
            let badge = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: size))
            badge.text = "1"
            badge.layer.cornerRadius = size / 2
            badge.layer.masksToBounds = true
            badge.textAlignment = .center
            badge.textColor = UIColor.white
            badge.backgroundColor = UIColor.red
            patchNotesCell.accessoryView = badge
        }
        else {
            patchNotesCell.accessoryView = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
