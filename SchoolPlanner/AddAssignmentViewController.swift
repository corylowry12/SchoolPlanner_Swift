//
//  AddAssignmentViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/20/21.
//

import Foundation
import UIKit

class AddAssignmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var notes: UITextView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classTableView.delegate = self
        classTableView.dataSource = self
        
        dueDate.minimumDate = Date()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
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
        assignments.name = nameTextField.text
            if notes.text == "" || notes.text == "Type Your Notes..." {
                assignments.notes = "None"
            }
            else {
                assignments.notes = notes.text
            }
            
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        self.navigationController?.popViewController(animated: true)
        }
    }
}
