//
//  AddClassViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/19/21.
//

import Foundation
import UIKit
import MultiSelectSegmentedControl
import CoreData

class AddClassViewContrller: ViewController, UITextFieldDelegate {
    
    @IBOutlet weak var multiSelect: MultiSelectSegmentedControl!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var className: UITextField!
    @IBOutlet weak var classLocation: UITextField!
    
    @IBOutlet weak var inTimePicker: UIDatePicker!
    @IBOutlet weak var outTimePicker: UIDatePicker!
    
    var editClass: Int! = 0
    var selectedIndex: Int! = 0
    
    var assignmentsData: [Assignments] {
        
        do {
            
            let fetchrequest = NSFetchRequest<Assignments>(entityName: "Assignments")
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Assignments]()
        
    }
    
    override var classes: [Classes] {
        
        do {
            
            return try context.fetch(Classes.fetchRequest())
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Classes]()
        
    }
    
    var editClassData: [Classes] {
        
        do {
            
            let fetchrequest = NSFetchRequest<Classes>(entityName: "Classes")
            
            fetchrequest.predicate = NSPredicate(format: "id == %d", selectedIndex)
            
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Classes]()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        multiSelect.allowsMultipleSelection = true
        multiSelect.items = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"]
        
        className.delegate = self
        classLocation.delegate = self
        
        if editClass == 1 {
            //multiSelect.selectedSegmentIndex = 0
            let indexSet = NSMutableIndexSet()
            if editClassData[0].time?.contains("Mon") == true {
                indexSet.add(0)
            }
            if editClassData[0].time?.contains("Tue") == true {
                indexSet.add(1)
            }
            if editClassData[0].time?.contains("Wed") == true {
                indexSet.add(2)
            }
            if editClassData[0].time?.contains("Thur") == true {
                indexSet.add(3)
            }
            if editClassData[0].time?.contains("Fri") == true {
                indexSet.add(4)
            }
            if editClassData[0].time?.contains("Sat") == true {
                indexSet.add(5)
            }
            if editClassData[0].time?.contains("Sun") == true {
                indexSet.add(6)
            }
            multiSelect.selectedSegmentIndexes = indexSet as IndexSet
            
            className.text = editClassData[0].name
            classLocation.text = editClassData[0].location
            
            inTimePicker.date = editClassData[0].intime!
            outTimePicker.date = editClassData[0].outtime!
            
            saveButton.title = "Update"
            navigationBar.title = "Update Class"
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if className.isFirstResponder {
            className.resignFirstResponder()
        }
        else if classLocation.isFirstResponder {
            classLocation.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        editClass = 0
        saveButton.title = "Save"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if editClass == 0 {
            if className.text == "" {
                let alert = UIAlertController(title: "Please enter a class name", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                    
                }
                print("index is: \(multiSelect.selectedSegmentTitles)")
            }
            else if multiSelect.selectedSegmentTitles == [] {
                let alert = UIAlertController(title: "Please select days that the class meets", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                    
                }
            }
            else if inTimePicker.date >= outTimePicker.date {
                let alert = UIAlertController(title: "Class start time can not be later or the same as class end time", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                    
                }
            }
            else if classLocation.text == "" {
                    let alert = UIAlertController(title: "Please enter the class location", message: nil, preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        alert.dismiss(animated: true, completion: nil)
                        
                    }
            }
            else {
                var alreadyStored = false
                if classes.count > 0 {
                for i in 0...classes.count - 1 {
                    if classes[i].name == className.text {
                        alreadyStored = true
                        break
                    }
                }
                }
                if alreadyStored == true {
                    let alert = UIAlertController(title: "Class already exists, please enter a diferent name", message: nil, preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        alert.dismiss(animated: true, completion: nil)
                        
                    }
                }
                else {
                    let classToStore = Classes(context: context)
                    var random : Int32!
                    do {
                        random = Int32.random(in: 1...500)
                    }
                    while self.classes.contains(where: { $0.id == random }) {
                        random = Int32.random(in: 1...500)
                    }
                    classToStore.id = random
                    classToStore.name = className.text
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "hh:mm a"
                    let inTime = dateFormatter.string(from: inTimePicker.date)
                    let outTime = dateFormatter.string(from: outTimePicker.date)
                    
                    let inTimeToStore = dateFormatter.date(from: inTime)
                    let outTimeToStore = dateFormatter.date(from: outTime)
                    
                    classToStore.intime = inTimeToStore
                    classToStore.outtime = outTimeToStore
                    var time : String!
                    //classToStore.time = time
                    if multiSelect.selectedSegmentTitles.count == 1 {
                        time = "\(inTime) - \(outTime) on \(multiSelect.selectedSegmentTitles.first ?? "Unknown")"
                        classToStore.time = time
                    }
                    else {
                        var days = ""
                        for i in multiSelect.selectedSegmentTitles {
                            print("time is: \(i)")
                            /*if i != multiSelect.selectedSegmentTitles.last && i != multiSelect.selectedSegmentTitles.first {
                             days += ", \(i)"
                             }
                             else if i == multiSelect.selectedSegmentTitles.first {
                             days += "\(i), "
                             }
                             else if i == multiSelect.selectedSegmentTitles.last {
                             days += i
                             }
                             else {
                             days += i
                             }*/
                            if i == multiSelect.selectedSegmentTitles.first {
                                days += "\(i)"
                            }
                            else if i != multiSelect.selectedSegmentTitles.first && i != multiSelect.selectedSegmentTitles.last {
                                days += ", \(i)"
                            }
                            else if i == multiSelect.selectedSegmentTitles.last {
                                days += " and \(i)"
                            }
                        }
                        
                        time = "\(inTime) - \(outTime) on \(days)"
                        classToStore.time = time
                    }
                    
                    
                    classToStore.location = classLocation.text
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            if className.text == "" {
                let alert = UIAlertController(title: "Class must have a name to update", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                    
                }
                print("index is: \(multiSelect.selectedSegmentTitles)")
            }
            else if multiSelect.selectedSegmentTitles == [] {
                let alert = UIAlertController(title: "You must have a class day selected to update", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                    
                }
            }
            else if inTimePicker.date >= outTimePicker.date {
                let alert = UIAlertController(title: "Class start time can not be later or the same as class end time", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                    
                }
            }
            else if classLocation.text == "" {
                
                let alert = UIAlertController(title: "Class must have a location to update", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
                    
                }
            }
            else {
                
                let classToUpdate = editClassData[0]
                
                if assignmentsData.count > 0 {
                for i in 0...assignmentsData.count - 1 {
                    if assignmentsData[i].assignmentClass == classToUpdate.name {
                        assignmentsData[i].assignmentClass = className.text
                    }
                }
                }
                
                classToUpdate.name = className.text
                classToUpdate.id = Int32(selectedIndex)
                classToUpdate.location = classLocation.text
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                let inTime = dateFormatter.string(from: inTimePicker.date)
                let outTime = dateFormatter.string(from: outTimePicker.date)
                
                var time : String!
                
                var days = ""
                for i in multiSelect.selectedSegmentTitles {
                    print("time is: \(i)")
                    
                    if i == multiSelect.selectedSegmentTitles.first {
                        days += "\(i)"
                    }
                    else if i != multiSelect.selectedSegmentTitles.first && i != multiSelect.selectedSegmentTitles.last {
                        days += ", \(i)"
                    }
                    else if i == multiSelect.selectedSegmentTitles.last {
                        days += " and \(i)"
                    }
                }
                
                time = "\(inTime) - \(outTime) on \(days)"
                classToUpdate.time = time
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
