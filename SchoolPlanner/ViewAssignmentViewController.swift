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
    @IBOutlet var addButton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    var name : String!
    
    var classes: [Classes] {
        
        do {
            
            let fetchrequest = NSFetchRequest<Classes>(entityName: "Classes")
            fetchrequest.predicate = NSPredicate(format: "name == %@", name as CVarArg)
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Classes]()
        
    }
    
    var grades: [Grades] {
        
        do {
            
            let fetchrequest = NSFetchRequest<Grades>(entityName: "Grades")
            let sort = NSSortDescriptor(key: #keyPath(Grades.date), ascending: false)
            fetchrequest.sortDescriptors = [sort]
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Grades]()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        
        if userDefaults.integer(forKey: "doneStatus") == 1 {
            doneButton.title = "Mark As Undone"
            
            nameLabel.text = "Assignment Name: \(doneAssignments[userDefaults.integer(forKey: "assignment")].name ?? "Unknown")"
            classLabel.text = "Class: \(doneAssignments[userDefaults.integer(forKey: "assignment")].assignmentClass ?? "Unknown")"
            dueDateLabel.text = "Due Date: \(doneAssignments[userDefaults.integer(forKey: "assignment")].dueDate ?? "Unknown")"
            notesLabel.text = "Notes: \(doneAssignments[userDefaults.integer(forKey: "assignment")].notes ?? "Unknown")"
            addButton.isEnabled = true
        }
        else if userDefaults.integer(forKey: "pastDue") == 1{
            nameLabel.text = "Assignment Name: \(pastDue[userDefaults.integer(forKey: "assignment")].name ?? "Unknown")"
            classLabel.text = "Class: \(pastDue[userDefaults.integer(forKey: "assignment")].assignmentClass ?? "Unknown")"
            dueDateLabel.text = "Due Date: \(pastDue[userDefaults.integer(forKey: "assignment")].dueDate ?? "Unknown")"
            notesLabel.text = "Notes: \(pastDue[userDefaults.integer(forKey: "assignment")].notes ?? "Unknown")"
            addButton.isEnabled = false
        }
        else {
            nameLabel.text = "Assignment Name: \(assignments[userDefaults.integer(forKey: "assignment")].name ?? "Unknown")"
            classLabel.text = "Class: \(assignments[userDefaults.integer(forKey: "assignment")].assignmentClass ?? "Unknown")"
            dueDateLabel.text = "Due Date: \(assignments[userDefaults.integer(forKey: "assignment")].dueDate ?? "Unknown")"
            notesLabel.text = "Notes: \(assignments[userDefaults.integer(forKey: "assignment")].notes ?? "Unknown")"
            addButton.isEnabled = false
        }
    }
    @IBAction func markAsDoneClicked(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard
        if userDefaults.integer(forKey: "doneStatus") == 1 {
            doneAssignments[userDefaults.integer(forKey: "assignment")].doneStatus = 0
        }
        else if userDefaults.integer(forKey: "pastDue") == 1 {
            pastDue[userDefaults.integer(forKey: "assignment")].doneStatus = 1
        }
        else {
            assignments[userDefaults.integer(forKey: "assignment")].doneStatus = 1
        }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addButton(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let alert = UIAlertController(title: "Add Grade?", message: "Would you like to add a grade for this assignment?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
            let alert = UIAlertController(title: "Add Grade", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Grade"
            })
            alert.addTextField(configurationHandler: { (weightTextField) in
                weightTextField.placeholder = "Weight"
            })
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [self] _ in
                let gradeTextField = alert.textFields![0]
                let weightTextField = alert.textFields![1]
            if userDefaults.integer(forKey: "doneStatus") == 1 {
            for i in 0...doneAssignments.count - 1 {
                name = doneAssignments[userDefaults.integer(forKey: "assignment")].assignmentClass
             
                    if doneAssignments[i].assignmentClass == doneAssignments[userDefaults.integer(forKey: "assignment")].assignmentClass {
                        let grades = Grades(context: context)
                        grades.id = classes[0].id
                        grades.name = doneAssignments[i].name
                        let date = dateFormatter.string(from: Date())
                        grades.date = date
                        if gradeTextField.text == "" {
                            grades.grade = 100.0
                        }
                        else {
                            grades.grade = Double("\(gradeTextField.text ?? "")")!
                        }
                        if weightTextField.text == "" {
                            grades.weight = 100.0
                        }
                        else {
                            grades.weight = Double("\(weightTextField.text ?? "")")!
                        }
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        break
                    }
            }
            }
                else if userDefaults.integer(forKey: "pastDue") == 1 {
                    for i in 0...pastDue.count - 1 {
                        name = pastDue[userDefaults.integer(forKey: "assignment")].assignmentClass
                        
                            if pastDue[i].assignmentClass == pastDue[userDefaults.integer(forKey: "assignment")].assignmentClass {
                                let grades = Grades(context: context)
                                grades.id = classes[0].id
                                grades.name = pastDue[i].name
                                let date = dateFormatter.string(from: Date())
                                grades.date = date
                                if gradeTextField.text == "" {
                                    grades.grade = 100.0
                                }
                                else {
                                    grades.grade = Double("\(gradeTextField.text ?? "")")!
                                }
                                if weightTextField.text == "" {
                                    grades.weight = 100.0
                                }
                                else {
                                    grades.weight = Double("\(weightTextField.text ?? "")")!
                                }
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                break
                            }
                    }
                }
                else {
                    for i in 0...assignments.count - 1 {
                        name = pastDue[userDefaults.integer(forKey: "assignment")].assignmentClass
                        
                            if assignments[i].assignmentClass == assignments[userDefaults.integer(forKey: "assignment")].assignmentClass {
                                let grades = Grades(context: context)
                                grades.id = classes[0].id
                                grades.name = assignments[i].name
                                let date = dateFormatter.string(from: Date())
                                grades.date = date
                                if gradeTextField.text == "" {
                                    grades.grade = 100.0
                                }
                                else {
                                    grades.grade = Double("\(gradeTextField.text ?? "")")!
                                }
                                if weightTextField.text == "" {
                                    grades.weight = 100.0
                                }
                                else {
                                    grades.weight = Double("\(weightTextField.text ?? "")")!
                                }
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                break
                            }
                    }
            }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
