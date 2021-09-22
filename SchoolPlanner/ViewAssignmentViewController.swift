//
//  ViewAssignmentViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/21/21.
//

import Foundation
import UIKit
import CoreData

class ViewAssignmentViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        
        if userDefaults.integer(forKey: "doneStatus") == 1 {
            doneButton.title = "Mark As Undone"
            
            nameLabel.text = "Assignment Name: \(doneAssignments[userDefaults.integer(forKey: "assignment")].name ?? "Unknown")"
            classLabel.text = "Class: \(doneAssignments[userDefaults.integer(forKey: "assignment")].assignmentClass ?? "Unknown")"
            dueDateLabel.text = "Due Date: \(doneAssignments[userDefaults.integer(forKey: "assignment")].dueDate ?? "Unknown")"
            notesLabel.text = "Notes: \(doneAssignments[userDefaults.integer(forKey: "assignment")].notes ?? "Unknown")"
        }
        else {
            nameLabel.text = "Assignment Name: \(assignments[userDefaults.integer(forKey: "assignment")].name ?? "Unknown")"
            classLabel.text = "Class: \(assignments[userDefaults.integer(forKey: "assignment")].assignmentClass ?? "Unknown")"
            dueDateLabel.text = "Due Date: \(assignments[userDefaults.integer(forKey: "assignment")].dueDate ?? "Unknown")"
            notesLabel.text = "Notes: \(assignments[userDefaults.integer(forKey: "assignment")].notes ?? "Unknown")"
        }
    }
    @IBAction func markAsDoneClicked(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard
        if userDefaults.integer(forKey: "doneStatus") == 1 {
            doneAssignments[userDefaults.integer(forKey: "assignment")].doneStatus = 0
        }
        else {
            assignments[userDefaults.integer(forKey: "assignment")].doneStatus = 1
        }
        self.navigationController?.popViewController(animated: true)
    }
}
