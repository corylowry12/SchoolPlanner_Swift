//
//  ViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/19/21.
//

import UIKit
import CoreData
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var index: Int!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var classes: [Classes] {
        
        do {
            
            return try context.fetch(Classes.fetchRequest())
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Classes]()
        
    }
    var predicate: Int32!
    var grades: [Grades] {
        
        do {
            
            let fetchrequest = NSFetchRequest<Grades>(entityName: "Grades")
            fetchrequest.predicate = NSPredicate(format: "id == %d", predicate as CVarArg)
            let sort = NSSortDescriptor(key: #keyPath(Grades.date), ascending: false)
            fetchrequest.sortDescriptors = [sort]
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Grades]()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let userDefaults = UserDefaults.standard
        
        if userDefaults.value(forKey: "appVersion") == nil || userDefaults.value(forKey: "appVersion") as? String != appVersion {
            tabBarController?.tabBar.items?[2].badgeValue = "1"
        }
        
        if UserDefaults.standard.value(forKey: "theme") == nil {
            UserDefaults.standard.set(2, forKey: "theme")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        noClassesStoredBackground()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = classes[indexPath.row].id
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(id, forKey: "id")
        performSegue(withIdentifier: "grades", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { (action, view, completionHandler) in
            let alert = UIAlertController(title: "Warning", message: "Would you like to delete this class? It can not be undone!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
                
                predicate = classes[indexPath.row].id
                if grades.count > 0 {
                for i in 0...grades.count - 1 {
                    let gradeToDelete = grades[i]
                    self.context.delete(gradeToDelete)
                }
                }
                
                let classToDelete = self.classes[indexPath.row]
                self.context.delete(classToDelete)
                
                self.tableView.deleteRows(at: [indexPath], with: .left)
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                noClassesStoredBackground()
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
                tableView.setEditing(false, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { [self] (action, view, completionHandler) in
           
            index = Int(classes[indexPath.row].id)
            performSegue(withIdentifier: "editClass", sender: nil)
        }
            
        action.backgroundColor = .systemOrange
        return UISwipeActionsConfiguration(actions: [action])
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if classes.count > 0 {
            let className = classes[indexPath.row]
            
            print("id is \(className.id)")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "classNameCell") as! ClassCell
            cell.classNameLabel.text = "Name: \(className.name ?? "")"
            if className.time == nil || className.time == "" {
                cell.classTimeLabel.text = "Unknown"
            }
            else {
                cell.classTimeLabel.text = "Time: \(className.time ?? "")"
            }
            if className.location == nil || className.location == "" {
                cell.classLocationLabel.text = "Unknown"
            }
            else {
                cell.classLocationLabel.text = "Location: \(className.location ?? "")"
            }
            
            let lblNameInitialize = UILabel()
            lblNameInitialize.frame.size = CGSize(width: 56.0, height: 56.0)
            lblNameInitialize.textColor = UIColor.white
            var twoLetters = [String]()
            var text : String!
            
            if ((className.name!.trimmingCharacters(in: .whitespaces)).contains(" ") == false)  {
                
                text = "\(className.name!.prefix(1))"
                print("no whitespace")
            }
            else {
                twoLetters = className.name!.split{$0 == " "}.map(String.init)
                let firstLetter = twoLetters[0].prefix(1)
                let secondLetter = twoLetters[1].prefix(1)
                text = "\(firstLetter)\(secondLetter)"
            }
            
            lblNameInitialize.text = "\(text ?? "C") "
            lblNameInitialize.textAlignment = NSTextAlignment.center
            if text == "M" || text == "m" {
                lblNameInitialize.backgroundColor = UIColor.systemBlue
            }
            else if text == "E" || text == "e" {
                lblNameInitialize.backgroundColor = UIColor.systemRed
            }
            else if text == "A" || text == "A" {
                lblNameInitialize.backgroundColor = UIColor.green
            }
            else if text == "B" || text == "B" {
                lblNameInitialize.backgroundColor = UIColor.cyan
            }
            else {
                lblNameInitialize.backgroundColor = UIColor.systemOrange
            }
            lblNameInitialize.layer.cornerRadius = 56.0
            lblNameInitialize.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            
            UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
            lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
            cell.logoImage.image = UIGraphicsGetImageFromCurrentImageContext()
            cell.logoImage.layer.cornerRadius = cell.logoImage.frame.size.width / 2
            cell.logoImage.contentMode = .scaleToFill
            
            
            UIGraphicsEndImageContext()
            
            return cell
        }
        let cell = UITableViewCell()
        cell.isHidden = true
        return cell
    }
    
    func noClassesStoredBackground() {
        if classes.count == 0 {
            
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.accessibilityFrame.size.width, height: self.accessibilityFrame.size.height))
            messageLabel.text = "There are currently no classes stored. Hit the + to add one."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel;
            
            tableView.separatorStyle = .none;
        }
        else {
            tableView.backgroundView = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editClass" {
            let dvc = segue.destination as! AddClassViewContrller
            dvc.editClass = 1
            dvc.selectedIndex = index
        }
    }
}

