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

class AddClassViewContrller: ViewController {
    
    @IBOutlet weak var multiSelect: MultiSelectSegmentedControl!
    
    @IBOutlet weak var className: UITextField!
    @IBOutlet weak var classLocation: UITextField!
    
    @IBOutlet weak var inTimePicker: UIDatePicker!
    @IBOutlet weak var outTimePicker: UIDatePicker!
    
    override var classes: [Classes] {
        
        do {
            
            return try context.fetch(Classes.fetchRequest())
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Classes]()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       multiSelect.allowsMultipleSelection = true
        multiSelect.items = ["Mon", "Tue", "Wed", "Thur", "Fri"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if className.text != "" && classLocation.text != "" && multiSelect.selectedSegmentIndexes != [] {
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
            print("time is \(time)")
        }
        
        classToStore.location = classLocation.text
       
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        self.navigationController?.popViewController(animated: true)
        }
        else {
            let alert = UIAlertController(title: "Do not leave anything blank", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                    alert.dismiss(animated: true, completion: nil)
            
            }
        }
    }
    
}
