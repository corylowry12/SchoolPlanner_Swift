//
//  AddGradeViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 10/16/21.
//

import Foundation
import UIKit
import CoreData

class AddGradeViewController: UIViewController {
    
    @IBOutlet weak var gradeNameTextField: UITextField!
    @IBOutlet weak var gradeTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    var isSaved = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let userDefaults = UserDefaults.standard
    var grades: [Grades] {
        
        do {
            
            let fetchrequest = NSFetchRequest<Grades>(entityName: "Grades")
            let predicate = userDefaults.integer(forKey: "id")
            fetchrequest.predicate = NSPredicate(format: "id == %d", predicate as CVarArg)
            let sort = NSSortDescriptor(key: #keyPath(Grades.date), ascending: false)
            fetchrequest.sortDescriptors = [sort]
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Grades]()
        
    }
    
    var classes: [Classes] {
        
        do {
            let fetchrequest = NSFetchRequest<Classes>(entityName: "Classes")
            let predicate = userDefaults.integer(forKey: "id")
            fetchrequest.predicate = NSPredicate(format: "id == %d", predicate as CVarArg)
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Classes]()
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let gradeText = "\(gradeTextField.text ?? "")"
        let weightText = "\(weightTextField.text ?? "")"
        
        if gradeNameTextField.text == "" {
            let alert = UIAlertController(title: "Grade Name Can Not Be Left Blank", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
                
            }
        }
        else if gradeTextField.text == "" {
            let alert = UIAlertController(title: "Grade Can Not Be Left Blank", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
                
            }
        }
        else if !gradeText.isNumeric {
            let alert = UIAlertController(title: "Grade Must Be A Number", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
                
            }
        }
        else if !weightText.isNumeric {
            let alert = UIAlertController(title: "Weight Must Be A Number", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
                
            }
        }
        else if gradeNameTextField.text != "" && weightTextField.text != "" && gradeText.isNumeric && weightText.isNumeric {
            let gradeToStore = Grades(context: context)
            gradeToStore.id = Int32(userDefaults.integer(forKey: "id"))
            gradeToStore.name = gradeNameTextField.text
            gradeToStore.grade = Double("\(gradeTextField.text ?? "")")!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date = dateFormatter.string(from: Date())
            gradeToStore.date = date
            if weightTextField.text == "" {
                gradeToStore.weight = 100.0
            }
            else {
                gradeToStore.weight = Double("\(weightTextField.text ?? "")")!
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            isSaved = true
            self.navigationController?.popViewController(animated: true)
        }
        else {
            let alert = UIAlertController(title: "There was an issue, Check your input", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
                
            }
        }
    }
}
