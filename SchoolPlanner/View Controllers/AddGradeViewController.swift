//
//  AddGradeViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 10/16/21.
//

import Foundation
import UIKit
import CoreData

var gradeNameTextField1 : UITextField!
var gradeTextField1 : UITextField!
var gradeWeightTextField1 : UITextField!

extension String  {
    var isnumberordouble: Bool { return Int(self) != nil || Double(self) != nil }
}

extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(downTapped)),
            UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain, target: self, action: #selector(upTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func upTapped() {
        
        if gradeTextField1.isFirstResponder {
            gradeNameTextField1.becomeFirstResponder()
        }
        else if gradeWeightTextField1.isFirstResponder {
            gradeTextField1.becomeFirstResponder()
        }
    }
    
    @objc func downTapped() {
        
        if gradeNameTextField1.isFirstResponder {
            gradeTextField1.becomeFirstResponder()
        }
        else if gradeTextField1.isFirstResponder {
            gradeWeightTextField1.becomeFirstResponder()
        }
    }
}

class AddGradeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var isEditingGrade = 0
    var index: Int!
    
    @IBOutlet weak var gradeNameTextField: UITextField! {
        didSet { gradeNameTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var gradeTextField: UITextField! {
        didSet { gradeTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var weightTextField: UITextField! {
        didSet { weightTextField?.addDoneCancelToolbar() }
    }
    
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
    
    func upTapped() {
        //if gradeTextField.isFirstResponder {
            print("hello world")
        //}
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveButton.title = "Save"
    }
    
    override func viewDidLoad() {
        
        gradeNameTextField.delegate = self
        
        gradeNameTextField1 = gradeNameTextField
        gradeTextField1 = gradeTextField
        gradeWeightTextField1 = weightTextField
        
        if isEditingGrade == 1 {
            navigationItem.title = "Edit Grade"
            saveButton.title = "Update"
            gradeNameTextField.text = "\(grades[index - 1].name ?? "")"
            gradeTextField.text = "\(grades[index-1].grade)"
            weightTextField.text = "\(grades[index-1].weight)"
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if gradeNameTextField.isFirstResponder {
            gradeNameTextField.resignFirstResponder()
        }
        else if gradeTextField.isFirstResponder {
            gradeTextField.resignFirstResponder()
        }
        else if weightTextField.isFirstResponder {
            weightTextField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let gradeText = "\(gradeTextField.text ?? "")"
        let weightText = "\(weightTextField.text ?? "")"
        
        if gradeNameTextField.text == "" || gradeNameTextField.text == nil {
            let alert = UIAlertController(title: "Grade Name Can Not Be Left Blank", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
                
            }
        }
        else if gradeTextField.text == "" || gradeTextField.text == nil {
            let alert = UIAlertController(title: "Grade Can Not Be Left Blank", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
                
            }
        }
        else if !gradeText.isnumberordouble {
            print(gradeText.isnumberordouble)
            let alert = UIAlertController(title: "Grade Must Be A Number", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
                
            }
        }
        else if Double(gradeText)! > 100 {
            let alert = UIAlertController(title: "Grade Can Not Be Greater than 100", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
                
            }
        }
        else if !weightText.isnumberordouble {
            let alert = UIAlertController(title: "Weight Must Be A Number", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
                
            }
        }
        else if weightText == "" {
            let alert = UIAlertController(title: nil, message: "Weight was left blank, would you like to make it 100?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
                self.weightTextField.text = "100"
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if Double(weightText)! > 100 {
            let alert = UIAlertController(title: "Weight Can Not Be Greater than 100", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
                
            }
        }
        else if gradeNameTextField.text != "" && weightTextField.text != "" && gradeText.isnumberordouble && weightText.isnumberordouble {
            if isEditingGrade == 1 {
                let gradeToEdit = grades[index-1]
                gradeToEdit.name = gradeNameTextField.text
                gradeToEdit.grade = Double("\(gradeTextField.text ?? "")")!
                if weightTextField.text == "" {
                    gradeToEdit.weight = 100.0
                }
                else {
                    gradeToEdit.weight = Double("\(weightTextField.text ?? "")")!
                }
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                isSaved = true
                self.navigationController?.popViewController(animated: true)
            }
            else {
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
