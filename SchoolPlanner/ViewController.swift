//
//  ViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/19/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
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
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if classes.count > 0 {
            let className = classes[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "classNameCell") as! ClassCell
            cell.classNameLabel.text = "Name: \(className.name ?? "")"
            if className.time == nil || className.time == "" {
                cell.classTimeLabel.text = "Unknown"
            }
            else {
                cell.classTimeLabel.text = "Time: \(className.time ?? "")"
            }
            if className.location == nil || className.location == "" {
                cell.classLocationLabel.text = "Unknown"
            }
            else {
                cell.classLocationLabel.text = "Location: \(className.location ?? "")"
            }
            
            let lblNameInitialize = UILabel()
            lblNameInitialize.frame.size = CGSize(width: 56.0, height: 56.0)
            lblNameInitialize.textColor = UIColor.white
            var twoLetters = [String]()
            var text : String!
            
            if ((className.name!.trimmingCharacters(in: .whitespaces)).contains(" ") == false)  {
                
                text = "\(className.name!.prefix(1))"
                print("no whitespace")
            }
            else {
                twoLetters = className.name!.split{$0 == " "}.map(String.init)
                let firstLetter = twoLetters[0].prefix(1)
                let secondLetter = twoLetters[1].prefix(1)
                text = "\(firstLetter)\(secondLetter)"
            }
            
            lblNameInitialize.text = "\(text ?? "C") "
            lblNameInitialize.textAlignment = NSTextAlignment.center
            if text == "M" || text == "m" {
                lblNameInitialize.backgroundColor = UIColor.systemBlue
            }
            else if text == "E" || text == "e" {
                lblNameInitialize.backgroundColor = UIColor.systemRed
            }
            else {
                lblNameInitialize.backgroundColor = UIColor.systemOrange
            }
            lblNameInitialize.layer.cornerRadius = 56.0
            lblNameInitialize.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            
            UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
            lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
            cell.logoImage.image = UIGraphicsGetImageFromCurrentImageContext()
            cell.logoImage.layer.cornerRadius = cell.logoImage.frame.size.width / 2
            cell.logoImage.contentMode = .scaleToFill
            
            
            UIGraphicsEndImageContext()
            
            return cell
        }
        let cell = UITableViewCell()
        cell.isHidden = true
        return cell
    }
    /*@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
     
     let alert = UIAlertController(title: "Class", message: "Enter Class Details", preferredStyle: .alert)
     alert.addTextField(configurationHandler: { (textField) in
     textField.placeholder = "Place holder"
     
     })
     alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [self] _ in
     let textField = alert.textFields![0] as UITextField
     let classToBeStored = Classes(context: context)
     classToBeStored.name = textField.text
     tableView.reloadData()
     }))
     alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
     present(alert, animated: true, completion: nil)
     }*/
}

