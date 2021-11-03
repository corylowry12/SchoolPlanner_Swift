//
//  AppearanceViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/21/21.
//
import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class AppearanceViewController: UITableViewController {
    
    @IBOutlet var themeTableView: UITableView!
    
    @IBOutlet weak var blueImageView: UIImageView!
    @IBOutlet weak var purpleImageView: UIImageView!
    @IBOutlet weak var tealImageView: UIImageView!
    @IBOutlet weak var orangeImageView: UIImageView!
    @IBOutlet weak var redImageView: UIImageView!
    
    let storedThemeValue = UserDefaults.standard.integer(forKey: "theme")
    let storedAccentValue = UserDefaults.standard.integer(forKey: "accent")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueImageView.layer.cornerRadius = blueImageView.frame.size.width / 2
        purpleImageView.layer.cornerRadius = purpleImageView.frame.size.width / 2
        tealImageView.layer.cornerRadius = tealImageView.frame.size.width / 2
        orangeImageView.layer.cornerRadius = orangeImageView.frame.size.width / 2
        redImageView.layer.cornerRadius = redImageView.frame.size.width / 2
        
        let indexPath = IndexPath(row: storedThemeValue, section: 0)
        themeTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        themeTableView.delegate?.tableView?(themeTableView, didSelectRowAt: indexPath)
        
        let indexPathAccent = IndexPath(row: storedAccentValue, section: 1)
        themeTableView.selectRow(at: indexPathAccent, animated: false, scrollPosition: .none)
        themeTableView.delegate?.tableView?(themeTableView, didSelectRowAt: indexPathAccent)
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
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                themeTableView.cellForRow(at: [1, UserDefaults.standard.integer(forKey: "accent")])?.accessoryType = .none
                let accent = UIColor(rgb: 0x347deb)
                UIView.transition(with: view.window ?? UIWindow(), duration: 0.5, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {
                    self.view.window?.tintColor = accent
                }, completion: nil)
                UserDefaults.standard.set(0, forKey: "accent")
                //changeIcon(nil)
                themeTableView.cellForRow(at: [1, UserDefaults.standard.integer(forKey: "accent")])?.accessoryType = .checkmark
            }
            else if indexPath.row == 1 {
                themeTableView.cellForRow(at: [1, UserDefaults.standard.integer(forKey: "accent")])?.accessoryType = .none
                let accent = UIColor(rgb: 0x7841c4)
                UIView.transition(with: view.window ?? UIWindow(), duration: 0.5, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {
                    self.view.window?.tintColor = accent
                }, completion: nil)
                UserDefaults.standard.set(1, forKey: "accent")
                //changeIcon("purple_logo")
                themeTableView.cellForRow(at: [1, UserDefaults.standard.integer(forKey: "accent")])?.accessoryType = .checkmark
            }
            else if indexPath.row == 2 {
                themeTableView.cellForRow(at: [1, UserDefaults.standard.integer(forKey: "accent")])?.accessoryType = .none
                let accent = UIColor(rgb: 0x26A69A)
                UIView.transition(with: view.window ?? UIWindow(), duration: 0.5, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {
                    self.view.window?.tintColor = accent
                }, completion: nil)
                UserDefaults.standard.set(2, forKey: "accent")
                //changeIcon("blue_logo")
                themeTableView.cellForRow(at: [1, UserDefaults.standard.integer(forKey: "accent")])?.accessoryType = .checkmark
            }
            else if indexPath.row == 3 {
                themeTableView.cellForRow(at: [1, UserDefaults.standard.integer(forKey: "accent")])?.accessoryType = .none
                let accent = UIColor(rgb: 0xfc783a)
                UIView.transition(with: view.window ?? UIWindow(), duration: 0.5, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {
                    self.view.window?.tintColor = accent
                }, completion: nil)
                UserDefaults.standard.set(3, forKey: "accent")
                //changeIcon("orange_logo")
                themeTableView.cellForRow(at: [1, UserDefaults.standard.integer(forKey: "accent")])?.accessoryType = .checkmark
            }
            else if indexPath.row == 4 {
                themeTableView.cellForRow(at: [1, UserDefaults.standard.integer(forKey: "accent")])?.accessoryType = .none
                let accent = UIColor(rgb: 0xc41d1d)
                UIView.transition(with: view.window ?? UIWindow(), duration: 0.5, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {
                    self.view.window?.tintColor = accent
                }, completion: nil)
                UserDefaults.standard.set(4, forKey: "accent")
                //changeIcon("red_logo")
                themeTableView.cellForRow(at: [1, UserDefaults.standard.integer(forKey: "accent")])?.accessoryType = .checkmark
            }
        }
    }
}
