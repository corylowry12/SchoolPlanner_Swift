//
//  HowToTableViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/22/21.
//
import UIKit

class HowToTableViewController: UITableViewController {
    
    var isSelected = false
    var section2IsSelected = false
    var section3IsSelected = false
    var section4IsSelected = false
    var section5IsSelected = false
    var section6IsSelected = false
    var section7IsSelected = false
    
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.tableFooterView = UIView()
        
        let downArrow = UIImage(systemName: "chevron.down")
        
        tableView.cellForRow(at: [0, 0])?.accessoryView = UIImageView(image: downArrow)
        tableView.cellForRow(at: [1, 0])?.accessoryView = UIImageView(image: downArrow)
        tableView.cellForRow(at: [2, 0])?.accessoryView = UIImageView(image: downArrow)
        tableView.cellForRow(at: [3, 0])?.accessoryView = UIImageView(image: downArrow)
        tableView.cellForRow(at: [4, 0])?.accessoryView = UIImageView(image: downArrow)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if isSelected == false {
                
                if indexPath.row == 1 {
                    tableView.cellForRow(at: [0, 1])?.backgroundColor = UIColor.clear
                    return 0
                }
                
            }
            else {
                if indexPath.row == 1 {
                    tableView.cellForRow(at: [0, 1])?.backgroundColor = UIColor.systemGray2
                    return 130
                }
            }
        }
        if indexPath.section == 1 {
            if section2IsSelected == false {
                
                if indexPath.row == 1 {
                    tableView.cellForRow(at: [1, 1])?.backgroundColor = UIColor.clear
                    return 0
                }
                if indexPath.row == 2 {
                    tableView.cellForRow(at: [1, 2])?.backgroundColor = UIColor.clear
                    return 0
                }
            }
            else {
                if indexPath.row == 1 {
                    tableView.cellForRow(at: [1, 1])?.backgroundColor = UIColor.systemGray2
                    return 130
                }
                if indexPath.row == 2 {
                    tableView.cellForRow(at: [1, 2])?.backgroundColor = UIColor.systemGray2
                    return 166
                }
            }
        }
        if indexPath.section == 2 {
            if section3IsSelected == false {
                
                if indexPath.row == 1 {
                    tableView.cellForRow(at: [2, 1])?.backgroundColor = UIColor.clear
                    return 0
                }
             
            }
            else {
                if indexPath.row == 1 {
                    tableView.cellForRow(at: [2, 1])?.backgroundColor = UIColor.systemGray2
                    return 115
                }
            }
        }
        if indexPath.section == 3 {
            if section4IsSelected == false {
                
                if indexPath.row == 1 {
                    tableView.cellForRow(at: [3, 1])?.backgroundColor = UIColor.clear
                    return 0
                }
            }
            else {
                if indexPath.row == 1 {
                    tableView.cellForRow(at: [3, 1])?.backgroundColor = UIColor.systemGray2
                    return 106
                }
            }
        }
        if indexPath.section == 4 {
            if section5IsSelected == false {
                
                if indexPath.row == 1 {
                    tableView.cellForRow(at: [4, 1])?.backgroundColor = UIColor.clear
                    return 0
                }
                if indexPath.row == 2 {
                    tableView.cellForRow(at: [4, 2])?.backgroundColor = UIColor.clear
                    return 0
                }
            }
            else {
                if indexPath.row == 1 {
                    tableView.cellForRow(at: [4, 1])?.backgroundColor = UIColor.systemGray2
                    return 115
                }
                if indexPath.row == 2 {
                    tableView.cellForRow(at: [4, 2])?.backgroundColor = UIColor.systemGray2
                    return 115
                }
            }
        }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let upArrow = UIImage(systemName: "chevron.up")
        let downArrow = UIImage(systemName: "chevron.down")
        print("index is \(indexPath)")
        if indexPath == [0, 0] {
            if isSelected == false {
                isSelected = true
                tableView.cellForRow(at: indexPath)?.accessoryView = UIImageView(image: upArrow)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            else {
                isSelected = false
                tableView.cellForRow(at: indexPath)?.accessoryView = UIImageView(image: downArrow)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        else if indexPath == [1, 0] {
            if section2IsSelected == false {
                section2IsSelected = true
                tableView.cellForRow(at: indexPath)?.accessoryView = UIImageView(image: upArrow)
                tableView.beginUpdates()
                tableView.endUpdates()
                let completelyVisible = tableView.bounds.contains(tableView.rectForRow(at: [1, 2]))
                
                if completelyVisible == false {
                    tableView.scrollToRow(at: [1, 2], at: .bottom, animated: true)
                }
            }
            else {
                section2IsSelected = false
                tableView.cellForRow(at: indexPath)?.accessoryView = UIImageView(image: downArrow)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        else if indexPath == [2, 0] {
            if section3IsSelected == false {
                section3IsSelected = true
                tableView.cellForRow(at: indexPath)?.accessoryView = UIImageView(image: upArrow)
                tableView.beginUpdates()
                tableView.endUpdates()
                let completelyVisible = tableView.bounds.contains(tableView.rectForRow(at: [2, 1]))
                
                if completelyVisible == false {
                    tableView.scrollToRow(at: [2, 1], at: .bottom, animated: true)
                }
            }
            else {
                section3IsSelected = false
                tableView.cellForRow(at: indexPath)?.accessoryView = UIImageView(image: downArrow)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        else if indexPath == [3, 0] {
            if section4IsSelected == false {
                section4IsSelected = true
                tableView.cellForRow(at: indexPath)?.accessoryView = UIImageView(image: upArrow)
                tableView.beginUpdates()
                tableView.endUpdates()
                let completelyVisible = tableView.bounds.contains(tableView.rectForRow(at: [3, 1]))
                
                if completelyVisible == false {
                    tableView.scrollToRow(at: [3, 1], at: .bottom, animated: true)
                }
            }
            else {
                section4IsSelected = false
                tableView.cellForRow(at: indexPath)?.accessoryView = UIImageView(image: downArrow)
                
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        else if indexPath == [4, 0] {
            if section5IsSelected == false {
                section5IsSelected = true
                tableView.cellForRow(at: indexPath)?.accessoryView = UIImageView(image: upArrow)
                tableView.beginUpdates()
                tableView.endUpdates()
                let completelyVisible = tableView.bounds.contains(tableView.rectForRow(at: [4, 2]))
                
                if completelyVisible == false {
                    tableView.scrollToRow(at: [4, 2], at: .bottom, animated: true)
                }
            }
            else {
                section5IsSelected = false
                tableView.cellForRow(at: indexPath)?.accessoryView = UIImageView(image: downArrow)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }
}

