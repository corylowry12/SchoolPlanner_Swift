//
//  AssignmentViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/20/21.
//

import Foundation
import UIKit
import CoreData

class AssignmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
            fetchrequest.predicate = NSPredicate(format: "doneStatus == %d", predicate as CVarArg)
            let sort = NSSortDescriptor(key: #keyPath(Assignments.dueDate), ascending: false)
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
        
        assignmentTableView.delegate = self
        assignmentTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        assignmentTableView.reloadData()
        print("count is \(assignments.count)")
        
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
        else {
            return doneAssignments.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Assigments"
        }
        else {
            return "Done"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(indexPath.row, forKey: "assignment")
            userDefaults.setValue(0, forKey: "doneStatus")
            performSegue(withIdentifier: "viewAssignment", sender: nil)
        }
        else {
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(indexPath.row, forKey: "assignment")
            userDefaults.setValue(1, forKey: "doneStatus")
            performSegue(withIdentifier: "viewAssignment", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { (action, view, completionHandler) in
            let alert = UIAlertController(title: "Warning", message: "Would you like to delete this assignment? It can not be undone!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
                if indexPath.section == 0 {
                    let assignmentToDelete = self.assignments[indexPath.row]
                    self.context.delete(assignmentToDelete)
                    
                    self.assignmentTableView.deleteRows(at: [indexPath], with: .left)
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
                else {
                    let assignmentToDelete = self.doneAssignments[indexPath.row]
                    self.context.delete(assignmentToDelete)
                    
                    self.assignmentTableView.deleteRows(at: [indexPath], with: .left)
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
                tableView.setEditing(false, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        var doneTitle : String!
        if indexPath.section == 0 {
            doneTitle = "Done"
        }
        else {
            doneTitle = "Undone"
        }
        let exportAction = UIContextualAction(style: .normal, title: doneTitle) { (action, view, completionHandler) in
            let alert = UIAlertController(title: "Warning", message: "You are fixing to mark item as done. Would you like to continue?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
                if indexPath.section == 0 {
                    
                    self.assignments[indexPath.row].doneStatus = 1
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    UIView.transition(with: assignmentTableView, duration: 0.5, options: .transitionCrossDissolve, animations: { [self] in
                        assignmentTableView.reloadData()
                    }, completion: nil)
                }
                else {
                    self.doneAssignments[indexPath.row].doneStatus = 0
                    
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
        }
        else {
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
        return cell
    }
    
}
