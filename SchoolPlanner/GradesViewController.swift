//
//  GradesViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/20/21.
//

import Foundation
import UIKit
import CoreData

class GradesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var gradeTableView: UITableView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradeTableView.delegate = self
        gradeTableView.dataSource = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("count is \(grades.count)")
        
        noGradesStoredBackground()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grades.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { (action, view, completionHandler) in
            let alert = UIAlertController(title: "Warning", message: "Would you like to delete this grade? It can not be undone!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
                let gradeToDelete = self.grades[indexPath.row - 1]
                self.context.delete(gradeToDelete)
                
                self.gradeTableView.deleteRows(at: [indexPath], with: .left)
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                self.noGradesStoredBackground()
                
                if self.grades.count == 0 {
                    tableView.cellForRow(at: [0, 0])?.isHidden = true
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
                tableView.setEditing(false, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row != 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if grades.count > 0 {
    if indexPath == [0, 0] {
        let averageCell = gradeTableView.dequeueReusableCell(withIdentifier: "averageCell") as! AverageCell
        
        var total = 0.0
        
        for i in 0...grades.count - 1 {
            total += grades[i].grade * (Double(grades[i].weight))
        }
            var average : Double! = 0.0
            var totalOfWeights = 0
            for i in 0...grades.count - 1 {
                totalOfWeights += Int(grades[i].weight)
            }
            average += total / Double(totalOfWeights)
        average = round(average * 100.0) / 100.0
            averageCell.averageLabel.text = "Average: \(average ?? 0.0)"
        return averageCell
        
    }
        else {
            let gradesData = grades[indexPath.row - 1]
            tableView.cellForRow(at: [0, 0])?.isHidden = false
            print("hello \(grades.count)")
            let cell = tableView.dequeueReusableCell(withIdentifier: "gradeCell") as! GradesTableViewCell
            cell.nameLabel.text = String("Name: \(gradesData.name ?? "Unknown")")
            cell.gradeLabel.text = String("Grade: \(gradesData.grade)")
            cell.weightLabel.text = String("Weight: \(gradesData.weight)")
            cell.dateLabel.text = String("Date: \(gradesData.date ?? "Unknown")")

            return cell
        }
        
        }
        let cell = UITableViewCell()
        cell.isHidden = true
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Grade", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (nameTextField) in
            nameTextField.placeholder = "Grade Name"
        })
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Grade"
        })
        alert.addTextField(configurationHandler: { (weightTextField) in
            weightTextField.placeholder = "Weight"
        })
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [self] _ in
            let nameTextField = alert.textFields![0]
            let gradeTextField = alert.textFields![1]
            let weightTextField = alert.textFields![2]
            if nameTextField.text != "" && gradeTextField.text != "" {
                let gradeToStore = Grades(context: context)
                gradeToStore.id = Int32(userDefaults.integer(forKey: "id"))
                gradeToStore.name = nameTextField.text
                gradeToStore.grade = Double("\(gradeTextField.text ?? "")")!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let date = dateFormatter.string(from: Date())
                gradeToStore.date = date
                if gradeTextField.text == "" {
                    gradeToStore.weight = 100.0
                }
                else {
                    gradeToStore.weight = Double("\(weightTextField.text ?? "")")!
                }
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                gradeTableView.reloadData()
                noGradesStoredBackground()
            }
            else {
                print("hello world")
            }
           
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func noGradesStoredBackground() {
        if grades.count == 0 {
            
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.accessibilityFrame.size.width, height: self.accessibilityFrame.size.height))
            messageLabel.text = "There are currently no grades stored. Hit the + to add one."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
            messageLabel.sizeToFit()
            self.gradeTableView.backgroundView = messageLabel;
            
            gradeTableView.separatorStyle = .none;
        }
        else {
            gradeTableView.backgroundView = nil
        }
    }
}
