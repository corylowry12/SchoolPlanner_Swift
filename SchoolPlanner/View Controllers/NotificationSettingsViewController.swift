//
//  NotificationSettingsViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/29/21.
//

import Foundation
import UIKit

class NotificationSettingsViewController: UIViewController {
    
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var toggleNotificationSwitch: UISwitch!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleNotificationSwitch.isOn = userDefaults.bool(forKey: "toggleNotifications")
        
        timePicker.isEnabled = userDefaults.bool(forKey: "toggleNotifications")
        
        timePicker.date = userDefaults.value(forKey: "time") as! Date
        
        appMovedToForeground()
        
    }
    
    @objc func appMovedToForeground() {
        print("App moved to ForeGround!")
        
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings(completionHandler: { [self] settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                print("authorized")
                timePicker.isEnabled = true
                toggleNotificationSwitch.isEnabled = true
            case .denied:
                print("denied")
                timePicker.isEnabled = false
                toggleNotificationSwitch.isEnabled = false
            case .notDetermined:
                print("not determined, ask user for permission now")
            default:
                print("unknown")
                timePicker.isEnabled = true
                toggleNotificationSwitch.isEnabled = true
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings(completionHandler: { [self] settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                print("authorized")
                timePicker.isEnabled = true
                toggleNotificationSwitch.isEnabled = true
            case .denied:
                print("denied")
                timePicker.isEnabled = false
                toggleNotificationSwitch.isEnabled = false
            case .notDetermined:
                print("not determined, ask user for permission now")
            default:
                print("unknown")
                timePicker.isEnabled = true
                toggleNotificationSwitch.isEnabled = true
            }
        })
    }
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "toggleNotifications")
        
        timePicker.isEnabled = userDefaults.bool(forKey: "toggleNotifications")
     
    }
    @IBAction func saveButton(_ sender: Any) {
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
        
        userDefaults.set(components.hour, forKey: "hour")
        userDefaults.set(components.minute, forKey: "minutes")
        userDefaults.set(timePicker.date, forKey: "time")
    }
}
