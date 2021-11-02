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
    @IBOutlet weak var categoryLabel: UILabel!
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
    var assignmentName: String!
    var gradesContains: [Grades] {
        
        do {
            
            let fetchrequest = NSFetchRequest<Grades>(entityName: "Grades")
            fetchrequest.predicate = NSPredicate(format: "name == %@", assignmentName as CVarArg)
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
            
            if doneAssignments[userDefaults.integer(forKey: "assignment")].category == 0 {
                categoryLabel.text = "Category: Exam"
            }
            else if doneAssignments[userDefaults.integer(forKey: "assignment")].category == 1 {
                categoryLabel.text = "Category: Homework"
            }
            else if doneAssignments[userDefaults.integer(forKey: "assignment")].category == 2 ||
                    doneAssignments[userDefaults.integer(forKey: "assignment")].category == 3 {
                categoryLabel.text = "Category: Other"
            }
            
            name = doneAssignments[userDefaults.integer(forKey: "assignment")].assignmentClass
            assignmentName = doneAssignments[userDefaults.integer(forKey: "assignment")].name
            var same = false
            if gradesContains.count > 0 {
            for i in 0...gradesContains.count - 1 {
                if gradesContains[i].name == doneAssignments[userDefaults.integer(forKey: "assignment")].name {
                    same = true
                    break
                }
            }
            if same == false {
            addButton.isEnabled = true
            }
            else {
                addButton.isEnabled = false
            }
            }
            else {
                addButton.isEnabled = true
            }
        }
        else if userDefaults.integer(forKey: "pastDue") == 1{
            nameLabel.text = "Assignment Name: \(pastDue[userDefaults.integer(forKey: "assignment")].name ?? "Unknown")"
            classLabel.text = "Class: \(pastDue[userDefaults.integer(forKey: "assignment")].assignmentClass ?? "Unknown")"
            dueDateLabel.text = "Due Date: \(pastDue[userDefaults.integer(forKey: "assignment")].dueDate ?? "Unknown")"
            notesLabel.text = "Notes: \(pastDue[userDefaults.integer(forKey: "assignment")].notes ?? "Unknown")"
            
            if pastDue[userDefaults.integer(forKey: "assignment")].category == 0 {
                categoryLabel.text = "Category: Exam"
            }
            else if pastDue[userDefaults.integer(forKey: "assignment")].category == 1 {
                categoryLabel.text = "Category: Homework"
            }
            else if pastDue[userDefaults.integer(forKey: "assignment")].category == 2 ||
                    pastDue[userDefaults.integer(forKey: "assignment")].category == 3 {
                categoryLabel.text = "Category: Other"
            }
            
            addButton.isEnabled = false
        }
        else {
            nameLabel.text = "Assignment Name: \(assignments[userDefaults.integer(forKey: "assignment")].name ?? "Unknown")"
            classLabel.text = "Class: \(assignments[userDefaults.integer(forKey: "assignment")].assignmentClass ?? "Unknown")"
            dueDateLabel.text = "Due Date: \(assignments[userDefaults.integer(forKey: "assignment")].dueDate ?? "Unknown")"
            notesLabel.text = "Notes: \(assignments[userDefaults.integer(forKey: "assignment")].notes ?? "Unknown")"
            
            if assignments[userDefaults.integer(forKey: "assignment")].category == 0 {
                categoryLabel.text = "Category: Exam"
            }
            else if assignments[userDefaults.integer(forKey: "assignment")].category == 1 {
                categoryLabel.text = "Category: Homework"
            }
            else if assignments[userDefaults.integer(forKey: "assignment")].category == 2 ||
                    assignments[userDefaults.integer(forKey: "assignment")].category == 3 {
                categoryLabel.text = "Category: Other"
            }
            
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
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
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
                print("name is \(doneAssignments[userDefaults.integer(forKey: "assignment")].name)")
                print("name is \(doneAssignments[i].name)")
                    if doneAssignments[i].assignmentClass == doneAssignments[userDefaults.integer(forKey: "assignment")].assignmentClass {
                        let gradeCount = grades.count
                        let gradesContext = Grades(context: context)
                        gradesContext.id = classes[0].id
                        gradesContext.name = doneAssignments[userDefaults.integer(forKey: "assignment")].name
                        let date = dateFormatter.string(from: Date())
                        gradesContext.date = date
                        if gradeTextField.text == "" {
                            gradesContext.grade = 100.0
                        }
                        else {
                            gradesContext.grade = Double("\(gradeTextField.text ?? "")")!
                        }
                        if weightTextField.text == "" {
                            gradesContext.weight = 100.0
                        }
                        else {
                            gradesContext.weight = Double("\(weightTextField.text ?? "")")!
                        }
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        if grades.count == gradeCount + 1 {
                            addButton.isEnabled = false
                        }
                        break
                    }
            }
            }
                else if userDefaults.integer(forKey: "pastDue") == 1 {
                    for i in 0...pastDue.count - 1 {
                        name = pastDue[userDefaults.integer(forKey: "assignment")].assignmentClass
                        
                            if pastDue[i].assignmentClass == pastDue[userDefaults.integer(forKey: "assignment")].assignmentClass {
                                let gradeCount = grades.count
                                let gradesContext = Grades(context: context)
                                gradesContext.id = classes[0].id
                                gradesContext.name = pastDue[i].name
                                let date = dateFormatter.string(from: Date())
                                gradesContext.date = date
                                if gradeTextField.text == "" {
                                    gradesContext.grade = 100.0
                                }
                                else {
                                    gradesContext.grade = Double("\(gradeTextField.text ?? "")")!
                                }
                                if weightTextField.text == "" {
                                    gradesContext.weight = 100.0
                                }
                                else {
                                    gradesContext.weight = Double("\(weightTextField.text ?? "")")!
                                }
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                if grades.count == gradeCount + 1 {
                                    addButton.isEnabled = false
                                }
                                break
                            }
                    }
                }
                else {
                    for i in 0...assignments.count - 1 {
                        name = pastDue[userDefaults.integer(forKey: "assignment")].assignmentClass
                        
                            if assignments[i].assignmentClass == assignments[userDefaults.integer(forKey: "assignment")].assignmentClass {
                                let gradeCount = grades.count
                                let gradesContext = Grades(context: context)
                                gradesContext.id = classes[0].id
                                gradesContext.name = assignments[i].name
                                let date = dateFormatter.string(from: Date())
                                gradesContext.date = date
            
                                if gradeTextField.text != "" && gradeTextField.text!.isNumeric {
                                    
                                    gradesContext.grade = Double("\(gradeTextField.text ?? "")")!
                                }
                                else {
                                    gradesContext.grade = 100.0
                                }
                                if weightTextField.text != "" && weightTextField.text!.isNumeric {
                                    gradesContext.weight = Double("\(weightTextField.text ?? "")")!
                                }
                                else {
                                    gradesContext.weight = 100.0
                                }
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                if grades.count == gradeCount + 1 {
                                    addButton.isEnabled = false
                                }
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
