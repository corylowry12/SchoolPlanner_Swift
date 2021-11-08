//
//  AddAssignmentViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/20/21.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

class AddAssignmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var notes: UITextView!
    
    var index: Int!
    var isEditingAssignment = 0
    var section : Int!
    
    var selectedCell = -1
    
    var assignmentName : String!
    var className: String!
    
    var notificationID : String!
    
    @IBOutlet weak var classTableView: UITableView!
    
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if notes.text == "" {
                notes.text = "Type Your Notes..."
            }
            notes.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc func notesTextViewTapped() {
        if notes.text == "Type Your Notes..." {
            notes.text = ""
        }
        notes.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        notes.delegate = self
        
        let tapTerm = UITapGestureRecognizer(target: self, action: #selector(notesTextViewTapped))
        
        notes.addGestureRecognizer(tapTerm)
        
        classTableView.delegate = self
        classTableView.dataSource = self
        
        classTableView.allowsMultipleSelection = false
        
        dueDate.minimumDate = Date()
        print("hello world \(isEditingAssignment)")
        if isEditingAssignment == 1 {
            navigationItem.title = "Edit Assignment"
            print("hello world")
            
            if section == 0 {
                let assignmentName = assignments[index].name
                nameTextField.text = assignmentName
                nameTextField.isEnabled = false
                notificationID = "\(assignments[index].name ?? "")\(assignments[index].dueDate ?? "")"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let date = dateFormatter.date(from: assignments[index].dueDate!)
                dueDate.date = date!
                
                categorySegmentedControl.selectedSegmentIndex = Int(assignments[index].category)
                
                if assignments[index].notes == "None" {
                    notes.text = "Type Your Notes..."
                }
                else {
                    notes.text = assignments[index].notes
                }
                for i in 0...classes.count - 1 {
                    if assignments[index].assignmentClass == classes[i].name {
                        let indexPath = IndexPath(row: i, section: 0)
                        classTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                        classTableView.delegate?.tableView?(classTableView, didSelectRowAt: indexPath)
                        
                        print("hello world")
                        break
                    }
                }
            }
            else if section == 1 {
                let assignmentName = pastDue[index].name
                nameTextField.text = assignmentName
                nameTextField.isEnabled = false
                notificationID = "\(pastDue[index].name ?? "")\(pastDue[index].dueDate ?? "")"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let date = dateFormatter.date(from: pastDue[index].dueDate!)
                dueDate.date = date!
                
                categorySegmentedControl.selectedSegmentIndex = Int(pastDue[index].category)
                
                if pastDue[index].notes == "None" {
                    notes.text = "Type Your Notes..."
                }
                else {
                    notes.text = pastDue[index].notes
                }
                for i in 0...classes.count - 1 {
                    if pastDue[index].assignmentClass == classes[i].name {
                        let indexPath = IndexPath(row: i, section: 0)
                        classTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                        classTableView.delegate?.tableView?(classTableView, didSelectRowAt: indexPath)
                        
                        print("hello world")
                        break
                    }
                }
            }
            else if section == 2 {
                let assignmentName = doneAssignments[index].name
                nameTextField.text = assignmentName
                nameTextField.isEnabled = false
                notificationID = "\(doneAssignments[index].name ?? "")\(doneAssignments[index].dueDate ?? "")"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let date = dateFormatter.date(from: doneAssignments[index].dueDate!)
                dueDate.date = date!
                
                categorySegmentedControl.selectedSegmentIndex = Int(doneAssignments[index].category)
                
                if doneAssignments[index].notes == "None" {
                    notes.text = "Type Your Notes..."
                }
                else {
                    notes.text = doneAssignments[index].notes
                }
                for i in 0...classes.count - 1 {
                    if doneAssignments[index].assignmentClass == classes[i].name {
                        let indexPath = IndexPath(row: i, section: 0)
                        classTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                        classTableView.delegate?.tableView?(classTableView, didSelectRowAt: indexPath)
                        
                        print("hello world")
                        break
                    }
                }
            }
        }
        else {
            categorySegmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "defaultCategory")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        classTableView.reloadData()
        
        if isEditingAssignment == 0 {
            categorySegmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "defaultCategory")
        }
        if selectedCell != -1 {
            classTableView.delegate?.tableView?(classTableView, didSelectRowAt: [0, selectedCell])
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Classes"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        let userDefaults = UserDefaults.standard
        if selectedCell == -1 {
            classTableView.cellForRow(at: [0, userDefaults.integer(forKey: "editAssignment")])?.accessoryType = .none
            
            userDefaults.set(indexPath.row, forKey: "editAssignment")
            classTableView.cellForRow(at: [0, userDefaults.integer(forKey: "editAssignment")])?.accessoryType = .checkmark
        }
        else {
            for i in 0...classes.count - 1 {
                classTableView.cellForRow(at: [0, i])?.accessoryType = .none
            }
            userDefaults.set(selectedCell, forKey: "editAssignment")
            classTableView.cellForRow(at: [0, selectedCell])?.accessoryType = .checkmark
        }
        print("selected cell is \(selectedCell)")
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Find any selected row in this section
        if let selectedIndexPath = classTableView.indexPathsForSelectedRows?.first(where: {
            $0.section == indexPath.section
        }) {
            // Deselect the row
            classTableView.deselectRow(at: selectedIndexPath, animated: false)
            // deselectRow doesn't fire the delegate method so need to
            // unset the checkmark here
            classTableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let classes = classes[indexPath.row]
        let cell = classTableView.dequeueReusableCell(withIdentifier: "classCell") as! AddAssignmentTableViewCell
        cell.classLabel.text = classes.name
        
        return cell
    }
    @IBAction func saveButton(_ sender: Any) {
        
        if isEditingAssignment == 0 {
            var selectedItem : Int! = 100000
            for i in 0...classes.count - 1 {
                if classTableView.cellForRow(at: [0, i])?.accessoryType == .checkmark {
                    selectedItem = i
                    break
                }
            }
            
            if nameTextField.text == "" {
                let alert = UIAlertController(title: "Don't leave assignment name blank", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
            else if selectedItem == 100000 {
                let alert = UIAlertController(title: "You must select a class", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
            
            else {
                let assignments = Assignments(context: context)
                
                for i in 0...classes.count - 1 {
                    if classTableView.cellForRow(at: [0, i])?.accessoryType == .checkmark {
                        selectedItem = i
                        break
                    }
                }
                let currentCell = classTableView.cellForRow(at: [0, selectedItem]) as! AddAssignmentTableViewCell
                
                let celltext = currentCell.classLabel.text
                
                assignments.assignmentClass = celltext
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let dueDateForAssignment = dateFormatter.string(from: dueDate.date)
                assignments.dueDate = dueDateForAssignment
                assignments.category = Int32(categorySegmentedControl.selectedSegmentIndex)
                print("selected item is \(categorySegmentedControl.selectedSegmentIndex)")
                
                assignments.name = nameTextField.text
                if notes.text == "" || notes.text == "Type Your Notes..." {
                    assignments.notes = "None"
                }
                else {
                    assignments.notes = notes.text
                }
                
                let components = Calendar.current.dateComponents([.month, .day, .year], from: dueDate.date)
                let month = components.month
                let day = components.day
                let year = components.year
                
                assignmentName = nameTextField.text
                className = currentCell.classLabel.text
                
                sendNotification(month: month!, day: day!, year: year!, name: "\(nameTextField.text!)\(dueDateForAssignment)")
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                self.navigationController?.popViewController(animated: true)
            }
        }
        else {
            var notification = [String]()
            UNUserNotificationCenter.current().getPendingNotificationRequests { [self] (notificationRequests) in
                for notificationRequest:UNNotificationRequest in notificationRequests {
                    print(notificationRequest.identifier)
                    if notificationRequest.identifier == "\(notificationID ?? "")" {
                        notification.append("\(notificationID ?? "")")
                    }
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notification)
            var selectedItem : Int! = 100000
            for i in 0...classes.count - 1 {
                if classTableView.cellForRow(at: [0, i])?.accessoryType == .checkmark {
                    selectedItem = i
                    break
                }
            }
            if nameTextField.text == "" {
                let alert = UIAlertController(title: "Don't leave assignment name blank", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
            else if selectedItem == 100000 {
                let alert = UIAlertController(title: "You must select a class", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
            
            else {
                if section == 0 {
                    let assignments = assignments[index]
                    
                    for i in 0...classes.count - 1 {
                        if classTableView.cellForRow(at: [0, i])?.accessoryType == .checkmark {
                            selectedItem = i
                            break
                        }
                    }
                    let currentCell = classTableView.cellForRow(at: [0, selectedItem]) as! AddAssignmentTableViewCell
                    
                    let celltext = currentCell.classLabel.text
                    
                    assignments.assignmentClass = celltext
                    assignments.category = Int32(categorySegmentedControl.selectedSegmentIndex)
                    print("selected item is \(categorySegmentedControl.selectedSegmentIndex)")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let dueDateForAssignment = dateFormatter.string(from: dueDate.date)
                    assignments.dueDate = dueDateForAssignment
                    assignments.name = nameTextField.text
                    if notes.text == "" || notes.text == "Type Your Notes..." {
                        assignments.notes = "None"
                    }
                    else {
                        assignments.notes = notes.text
                    }
                    
                    assignmentName = nameTextField.text
                    className = currentCell.classLabel.text
                    
                    let components = Calendar.current.dateComponents([.month, .day, .year], from: dueDate.date)
                    let month = components.month
                    let day = components.day
                    let year = components.year
                    
                    sendNotification(month: month!, day: day!, year: year!, name: "\(nameTextField.text!)\(dueDateForAssignment)")
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    self.navigationController?.popViewController(animated: true)
                }
                else if section == 1 {
                    let assignments = pastDue[index]
                    
                    for i in 0...classes.count - 1 {
                        if classTableView.cellForRow(at: [0, i])?.accessoryType == .checkmark {
                            selectedItem = i
                            break
                        }
                    }
                    let currentCell = classTableView.cellForRow(at: [0, selectedItem]) as! AddAssignmentTableViewCell
                    
                    let celltext = currentCell.classLabel.text
                    
                    assignments.assignmentClass = celltext
                    assignments.category = Int32(categorySegmentedControl.selectedSegmentIndex)
                    print("selected item is \(categorySegmentedControl.selectedSegmentIndex)")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let dueDateForAssignment = dateFormatter.string(from: dueDate.date)
                    assignments.dueDate = dueDateForAssignment
                    assignments.name = nameTextField.text
                    if notes.text == "" || notes.text == "Type Your Notes..." {
                        assignments.notes = "None"
                    }
                    else {
                        assignments.notes = notes.text
                    }
                    
                    assignmentName = nameTextField.text
                    className = currentCell.classLabel.text
                    
                    let components = Calendar.current.dateComponents([.month, .day, .year], from: dueDate.date)
                    let month = components.month
                    let day = components.day
                    let year = components.year
                    
                    sendNotification(month: month!, day: day!, year: year!, name: "\(nameTextField.text!)\(dueDateForAssignment)")
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
            
        }
    }
    
    func sendNotification(month: Int, day: Int, year: Int, name: String) {
        
        if UserDefaults.standard.bool(forKey: "toggleNotifications") == true {
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Assignment Due Today", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "Don't forget \(assignmentName ?? "homework") is due today in \(className ?? "one of your classes")", arguments: nil)
            content.sound = UNNotificationSound.default
            //let badgeCount = UIApplication.shared.applicationIconBadgeNumber as NSNumber
            content.badge = 1
            
            let identifier = name
            
            //Receive with date
            var dateInfo = DateComponents()
            dateInfo.day = day //Put your day
            dateInfo.month = month //Put your month
            dateInfo.year = year // Put your year
            dateInfo.hour = UserDefaults.standard.integer(forKey: "hour") //Put your hour
            dateInfo.minute = UserDefaults.standard.integer(forKey: "minutes") //put your minutes
            
            //specify if repeats or no
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            print(identifier)
            center.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }else{
                    print("send!!")
                }
            }
        }
    }
}
