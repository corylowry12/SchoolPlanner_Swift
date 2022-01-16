//
//  SettingsTableViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/23/21.
//

import Foundation
import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
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
        
        if indexPath.section == 6 {
            if MFMailComposeViewController.canSendMail() {
                let alert = UIAlertController(title: "Feedback", message: "What type of feedback would you like to give?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Bug", style: .default, handler: {_ in
                    self.sendBugEmail()
                }))
                alert.addAction(UIAlertAction(title: "Feature Request", style: .default, handler: {_ in
                    self.sendFeatureRequestEmail()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            
            }
            else {
                let alert = UIAlertController(title: "Cant send feedback right now. Try again later.", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    func sendBugEmail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setToRecipients(["corylowry12@gmail.com"])
            composeVC.setSubject("Bug Report")
            composeVC.setMessageBody("", isHTML: false)
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    
    func sendFeatureRequestEmail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setToRecipients(["corylowry12@gmail.com"])
            composeVC.setSubject("Feature Request")
            composeVC.setMessageBody("", isHTML: false)
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "Feedback sent successfully! Thank You!", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
            
        }
    }
}
