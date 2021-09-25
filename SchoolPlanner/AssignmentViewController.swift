//
//  AssignmentViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/20/21.
//

import Foundation
import UIKit
import CoreData
import GoogleMobileAds
import UserNotifications

class AssignmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var bannerView: GADBannerView! = GADBannerView(adSize: kGADAdSizeBanner)
    
    @IBOutlet weak var assignmentTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var classes: [Classes] {
        
        do {
            
            return try context.fetch(Classes.fetchRequest())
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Classes]()
        
    }
    
    var assignments: [Assignments] {
        
        do {
            
            let fetchrequest = NSFetchRequest<Assignments>(entityName: "Assignments")
            let predicate = 0
            
            let now: Date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date = dateFormatter.string(from: now)
            let predicate2: NSPredicate = NSPredicate(format: "dueDate >= %@", date)
            let predicate1 = NSPredicate(format: "doneStatus == %d", predicate as CVarArg)
            let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate1, predicate2])
            fetchrequest.predicate = andPredicate
            let sort = NSSortDescriptor(key: #keyPath(Assignments.dueDate), ascending: true)
            fetchrequest.sortDescriptors = [sort]
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Assignments]()
        
    }
    
    var pastDue: [Assignments] {
        
        do {
            let fetchrequest = NSFetchRequest<Assignments>(entityName: "Assignments")
            let predicate = 0
            
            let now: Date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date = dateFormatter.string(from: now)
            let predicate2: NSPredicate = NSPredicate(format: "dueDate < %@", date)
            let predicate1 = NSPredicate(format: "doneStatus == %d", predicate as CVarArg)
            let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate1, predicate2])
            fetchrequest.predicate = andPredicate
            let sort = NSSortDescriptor(key: #keyPath(Assignments.dueDate), ascending: true)
            fetchrequest.sortDescriptors = [sort]
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Assignments]()
        
    }
    
    var doneAssignments: [Assignments] {
        
        do {
            
            let fetchrequest = NSFetchRequest<Assignments>(entityName: "Assignments")
            let predicate = 1
            fetchrequest.predicate = NSPredicate(format: "doneStatus == %d", predicate as CVarArg)
            let sort = NSSortDescriptor(key: #keyPath(Assignments.dueDate), ascending: false)
            fetchrequest.sortDescriptors = [sort]
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Assignments]()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-4546055219731501/4458073112"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        assignmentTableView.delegate = self
        assignmentTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        assignmentTableView.reloadData()
        
        view.backgroundColor = assignmentTableView.backgroundColor
        
        noAssignmentStoredBackground()
        
        if classes.count == 0 {
            addButton.isEnabled = false
        }
        else {
            addButton.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return assignments.count
        }
        else if section == 2 {
            return doneAssignments.count
        }
        else {
            return pastDue.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if assignments.count != 0 || doneAssignments.count != 0 || pastDue.count != 0 {
            if section == 0 {
                return "Assigments: \(assignments.count)"
            }
            else if section == 2 {
                return "Done: \(doneAssignments.count)"
            }
            else {
                return "Past Due: \(pastDue.count)"
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(indexPath.row, forKey: "assignment")
            userDefaults.setValue(0, forKey: "doneStatus")
            userDefaults.setValue(0, forKey: "pastDue")
            performSegue(withIdentifier: "viewAssignment", sender: nil)
        }
        else if indexPath.section == 2 {
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(indexPath.row, forKey: "assignment")
            userDefaults.setValue(1, forKey: "doneStatus")
            userDefaults.setValue(0, forKey: "pastDue")
            performSegue(withIdentifier: "viewAssignment", sender: nil)
        }
        else if indexPath.section == 1 {
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(indexPath.row, forKey: "assignment")
            userDefaults.setValue(0, forKey: "doneStatus")
            userDefaults.setValue(1, forKey: "pastDue")
            performSegue(withIdentifier: "viewAssignment", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { (action, view, completionHandler) in
            let alert = UIAlertController(title: "Warning", message: "Would you like to delete this assignment? It can not be undone!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
                if indexPath.section == 0 {
                  
                      /* var identifiers: [String] = []
                       
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        let date = dateFormatter.date(from: assignments[indexPath.row].dueDate ?? "")
                        let identifier = "\(assignments[indexPath.row].name!)\(date!)"
                              identifiers.append(identifier)*/
                    let name = assignments[indexPath.row].name!
                        
                    var notification = [String]()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let date = dateFormatter.date(from: assignments[indexPath.row].dueDate ?? "")
                    UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                         for notificationRequest:UNNotificationRequest in notificationRequests {
                            print(notificationRequest.identifier)
                            if notificationRequest.identifier == "\(name)\(date!)" {
                                notification.append("\(assignments[indexPath.row].name!)\(date!)")
                            }
                        }
                    }
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notification)
                    let assignmentToDelete = self.assignments[indexPath.row]
                    self.context.delete(assignmentToDelete)
                    
                    self.assignmentTableView.deleteRows(at: [indexPath], with: .left)
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    if assignments.count == 0 && doneAssignments.count == 0 && pastDue.count == 0 {
                        self.assignmentTableView.reloadData()
                    }
                    
                    //let cell = assignmentTableView.cellForRow(at: indexPath) as! AssignmentTableViewCell
                    
                    
                    
                }
                else if indexPath.section == 2 {
                    let assignmentToDelete = self.doneAssignments[indexPath.row]
                    self.context.delete(assignmentToDelete)
                    
                    self.assignmentTableView.deleteRows(at: [indexPath], with: .left)
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    if assignments.count == 0 && doneAssignments.count == 0 && pastDue.count == 0 {
                        self.assignmentTableView.reloadData()
                    }
                }
                else if indexPath.section == 1 {
                    let assignmentToDelete = self.pastDue[indexPath.row]
                    self.context.delete(assignmentToDelete)
                    
                    self.assignmentTableView.deleteRows(at: [indexPath], with: .left)
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    if assignments.count == 0 && doneAssignments.count == 0 && pastDue.count == 0 {
                        self.assignmentTableView.reloadData()
                    }
                }
                noAssignmentStoredBackground()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
                tableView.setEditing(false, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        var doneTitle : String!
        var doneMessage : String!
        if indexPath.section == 0 {
            doneTitle = "Done"
            doneMessage = "You are fixing to mark item as done. Would you like to continue?"
        }
        else if indexPath.section == 1 {
            doneTitle = "Done"
            doneMessage = "You are fixing to mark item as done. Would you like to continue?"
        }
        else {
            doneTitle = "Undone"
            doneMessage = "You are fixing to mark item as undone. Would you like to continue?"
        }
        
        let exportAction = UIContextualAction(style: .normal, title: doneTitle) { (action, view, completionHandler) in
            let alert = UIAlertController(title: "Warning", message: doneMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
                if indexPath.section == 0 {
                    
                    self.assignments[indexPath.row].doneStatus = 1
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    UIView.transition(with: assignmentTableView, duration: 0.5, options: .transitionCrossDissolve, animations: { [self] in
                        assignmentTableView.reloadData()
                    }, completion: nil)
                }
                else if indexPath.section == 2 {
                    self.doneAssignments[indexPath.row].doneStatus = 0
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    UIView.transition(with: assignmentTableView, duration: 0.5, options: .transitionCrossDissolve, animations: { [self] in
                        assignmentTableView.reloadData()
                    }, completion: nil)
                    
                }
                else {
                    self.pastDue[indexPath.row].doneStatus = 1
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    UIView.transition(with: assignmentTableView, duration: 0.5, options: .transitionCrossDissolve, animations: { [self] in
                        assignmentTableView.reloadData()
                    }, completion: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
                completionHandler(false)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [action, exportAction])
        action.backgroundColor = .systemRed
        exportAction.backgroundColor = .systemBlue
        return swipeActionConfig
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = assignmentTableView.dequeueReusableCell(withIdentifier: "assignmentCell") as! AssignmentTableViewCell
        if indexPath.section == 0 {
            let assignments = assignments[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date = dateFormatter.date(from: assignments.dueDate!)
            //if date! > Date() {
            cell.nameLabel.text = "Name: \(assignments.name ?? "Unknown")"
            cell.classLabel.text = "Class: \(assignments.assignmentClass ?? "Unknown")"
            
            cell.dueDateLabel.text = "Due Date: \(assignments.dueDate ?? "Unknown")"
            
            if (assignments.notes?.count)! >= 35 {
                
                let index = assignments.notes?.index((assignments.notes?.startIndex)!, offsetBy: 25)
                cell.notesLabel.text = "Notes: \(assignments.notes?.substring(to: index!) ?? "Unknown")"
                cell.notesLabel.text = cell.notesLabel.text?.appending("...")
            }
            else {
                cell.notesLabel.text = "Notes: \(assignments.notes ?? "Unknown")"
            }
            //}
        }
        else if indexPath.section == 2 {
            let doneAssignments = doneAssignments[indexPath.row]
            cell.nameLabel.text = "Name: \(doneAssignments.name ?? "Unknown")"
            cell.classLabel.text = "Class: \(doneAssignments.assignmentClass ?? "Unknown")"
            cell.dueDateLabel.text = "Due Date: \(doneAssignments.dueDate ?? "Unknown")"
            
            if (doneAssignments.notes?.count)! >= 35 {
                
                let index = doneAssignments.notes?.index((doneAssignments.notes?.startIndex)!, offsetBy: 25)
                cell.notesLabel.text = "Notes: \(doneAssignments.notes?.substring(to: index!) ?? "Unknown")"
                cell.notesLabel.text = cell.notesLabel.text?.appending("...")
            }
            else {
                cell.notesLabel.text = "Notes: \(doneAssignments.notes ?? "Unknown")"
            }
        }
        else if indexPath.section == 1 {
            let assignments = pastDue[indexPath.row]
            //let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "MM/dd/yyyy"
            //let date = dateFormatter.date(from: assignments.dueDate!)
            //if date! > Date() {
            cell.nameLabel.text = "Name: \(assignments.name ?? "Unknown")"
            cell.classLabel.text = "Class: \(assignments.assignmentClass ?? "Unknown")"
            
            cell.dueDateLabel.text = "Due Date: \(assignments.dueDate ?? "Unknown")"
            
            if (assignments.notes?.count)! >= 35 {
                
                let index = assignments.notes?.index((assignments.notes?.startIndex)!, offsetBy: 25)
                cell.notesLabel.text = "Notes: \(assignments.notes?.substring(to: index!) ?? "Unknown")"
                cell.notesLabel.text = cell.notesLabel.text?.appending("...")
            }
            else {
                cell.notesLabel.text = "Notes: \(assignments.notes ?? "Unknown")"
            }
            //}
        }
        return cell
    }
    func noAssignmentStoredBackground() {
        if assignments.count == 0 && doneAssignments.count == 0 && pastDue.count == 0 {
            
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.accessibilityFrame.size.width, height: self.accessibilityFrame.size.height))
            messageLabel.text = "There are no assignments stored. Hit the + to add one. (+ Button will be disabled if there is no classes stored.)"
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
            messageLabel.sizeToFit()
            
            self.assignmentTableView.backgroundView = messageLabel;
            
            assignmentTableView.separatorStyle = .none;
        }
        else {
            assignmentTableView.backgroundView = nil
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}
