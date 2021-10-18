//
//  AllGradesViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/24/21.
//

import Foundation
import UIKit
import CoreData

class AllGradesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var gradesTableViewController: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var classes: [Classes] {
        
        do {
            
            return try context.fetch(Classes.fetchRequest())
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Classes]()
        
    }
    
    var id : Int32!
    
    var grades: [Grades] {
        
        do {
            
            let fetchrequest = NSFetchRequest<Grades>(entityName: "Grades")
            let predicate = id
            fetchrequest.predicate = NSPredicate(format: "id == %d", predicate!)
            let sort = NSSortDescriptor(key: #keyPath(Grades.date), ascending: false)
            fetchrequest.sortDescriptors = [sort]
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Grades]()
        
    }
    
    override func viewDidLoad() {
        gradesTableViewController.delegate = self
        gradesTableViewController.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gradesTableViewController.reloadData()
        noGradesStoredBackground()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = classes[indexPath.row].id
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(id, forKey: "id")
        performSegue(withIdentifier: "grades", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if classes.count > 0 {
        return "Grades"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let classes = classes[indexPath.row]
        let cell = gradesTableViewController.dequeueReusableCell(withIdentifier: "classGrades") as! AllGradesTableViewCell
        id = classes.id
        
        var total = 0.0
        
        if grades.count > 0 {
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
            cell.classLabel.text = "Class: \(classes.name ?? "")"
            cell.averageLabel.text = "Average: \(average ?? 0.0)%"
            if average >= 90 {
            cell.averageLabel.textColor = UIColor.systemGreen
            }
            else if average >= 80 {
                cell.averageLabel.textColor = UIColor.systemYellow
            }
            else if average >= 70 {
                cell.averageLabel.textColor = UIColor.systemOrange
            }
            else if average >= 60 {
                cell.averageLabel.textColor = UIColor.magenta
            }
            else {
                cell.averageLabel.textColor = UIColor.red
            }
        }
        else {
            cell.classLabel.text = "Class: \(classes.name ?? "")"
            cell.averageLabel.text = "Average: \(0.0)%"
        }
        
        return cell
    }
    
    func noGradesStoredBackground() {
        if classes.count == 0 {
            
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.accessibilityFrame.size.width, height: self.accessibilityFrame.size.height))
            messageLabel.text = "There are currently no classes or grades stored"
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
            messageLabel.sizeToFit()
            gradesTableViewController.backgroundView = messageLabel;
            
            gradesTableViewController.separatorStyle = .none;
        }
        else {
            gradesTableViewController.backgroundView = nil
        }
    }
}
