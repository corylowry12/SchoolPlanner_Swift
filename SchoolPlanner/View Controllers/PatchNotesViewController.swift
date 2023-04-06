//
//  PatchNotesViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/22/21.
//

import UIKit

class PatchNotesViewController: UITableViewController {
    
   
    @IBOutlet var tableViewPatchNotes: UITableView!
    
    var bugFixesBool = false
    var newFeaturesBool = false
    var enhancementsBool = false
    
    var bugFixesArray : [String] = ["Fixed some UI issues in the How To view"]
    var newFeaturesArray : [String] = []
    var enhancementsArray : [String] = ["Added support for iOS 16.4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewPatchNotes.delegate = self
        tableViewPatchNotes.dataSource = self
        
        tableViewPatchNotes.tableFooterView = UIView()
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let userDefaults = UserDefaults.standard
        userDefaults.set(appVersion, forKey: "appVersion")
        tabBarController?.tabBar.items?[2].badgeValue = nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && !bugFixesBool {
            return 1
        }
        else if section == 0 && bugFixesBool {
            return bugFixesArray.count + 1
        }
        else if section == 1 && !newFeaturesBool {
            return 1
        }
        else if section == 1 && newFeaturesBool {
            return newFeaturesArray.count + 1
        }
        else if section == 2 && !enhancementsBool {
            return 1
        }
        else if section == 2 && enhancementsBool {
            return enhancementsArray.count + 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewPatchNotes.deselectRow(at: indexPath, animated: true)
        if indexPath == [0, 0] {
            bugFixesBool = !bugFixesBool
           
            tableViewPatchNotes.beginUpdates()
            let tableViewHeaderCell = tableViewPatchNotes.cellForRow(at: [0,0]) as! PatchNotesTableViewHeaderCell
            if bugFixesBool {
                
                if bugFixesArray.count > 0 {
                tableViewHeaderCell.chevronImage.image = UIImage(systemName: "chevron.up")
              
            for i in 1...bugFixesArray.count {
                
                let indexPathInsert = IndexPath(row: i, section: 0)
                tableViewPatchNotes.insertRows(at: [indexPathInsert], with: .fade)
            }
                }
            }
            else {
                if bugFixesArray.count > 0 {
                tableViewHeaderCell.chevronImage.image = UIImage(systemName: "chevron.down")
                for i in (1...bugFixesArray.count).reversed() {
                    
                    let indexPathInsert = IndexPath(row: i, section: 0)
                    tableViewPatchNotes.deleteRows(at: [indexPathInsert], with: .fade)
                }
            }
            }
            tableViewPatchNotes.endUpdates()
        }
        else if indexPath == [1, 0] {
            newFeaturesBool = !newFeaturesBool
           
            tableViewPatchNotes.beginUpdates()
            let tableViewHeaderCell = tableViewPatchNotes.cellForRow(at: [1,0]) as! PatchNotesTableViewHeaderCell
            if newFeaturesBool {
                
                if newFeaturesArray.count > 0 {
                tableViewHeaderCell.chevronImage.image = UIImage(systemName: "chevron.up")
              
            for i in 1...newFeaturesArray.count {
                
                let indexPathInsert = IndexPath(row: i, section: 1)
                tableViewPatchNotes.insertRows(at: [indexPathInsert], with: .fade)
            }
                }
            }
            else {
                if newFeaturesArray.count > 0 {
                tableViewHeaderCell.chevronImage.image = UIImage(systemName: "chevron.down")
                for i in (1...newFeaturesArray.count).reversed() {
                    
                    let indexPathInsert = IndexPath(row: i, section: 1)
                    tableViewPatchNotes.deleteRows(at: [indexPathInsert], with: .fade)
                }
            }
            }
            tableViewPatchNotes.endUpdates()
        }
        
        else if indexPath == [2, 0] {
            enhancementsBool = !enhancementsBool
           
            tableViewPatchNotes.beginUpdates()
            let tableViewHeaderCell = tableViewPatchNotes.cellForRow(at: [2,0]) as! PatchNotesTableViewHeaderCell
            if enhancementsBool {
                
                if enhancementsArray.count > 0 {
                tableViewHeaderCell.chevronImage.image = UIImage(systemName: "chevron.up")
              
            for i in 1...enhancementsArray.count {
                
                let indexPathInsert = IndexPath(row: i, section: 2)
                tableViewPatchNotes.insertRows(at: [indexPathInsert], with: .fade)
            }
                }
            }
            else {
                if enhancementsArray.count > 0 {
                tableViewHeaderCell.chevronImage.image = UIImage(systemName: "chevron.down")
                for i in (1...enhancementsArray.count).reversed() {
                    
                    let indexPathInsert = IndexPath(row: i, section: 2)
                    tableViewPatchNotes.deleteRows(at: [indexPathInsert], with: .fade)
                }
            }
            }
            tableViewPatchNotes.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "patchNotesHeaderCell", for: indexPath) as! PatchNotesTableViewHeaderCell
        let contentCell = tableView.dequeueReusableCell(withIdentifier: "patchNotesCell", for: indexPath) as! PatchNotesTableViewCell
        
        if indexPath.section == 0 && !bugFixesBool {
            
        headerCell.headerLabel.text = "Bug Fixes"
            headerCell.counterLabel.text = "\(bugFixesArray.count)"
            return headerCell
        }
        else if indexPath.section == 0 && bugFixesBool {
            if indexPath.row == 0 {
            headerCell.headerLabel.text = "Bug Fixes"
                headerCell.counterLabel.text = "\(bugFixesArray.count)"
                return headerCell
            }
            else if indexPath.row > 0 {
                contentCell.contentLabel.text = bugFixesArray[indexPath.row - 1]
                
                    return contentCell
            }
        }
        else if indexPath.section == 1 && !newFeaturesBool {
            headerCell.headerLabel.text = "New Features"
            headerCell.counterLabel.text = "\(newFeaturesArray.count)"
                return headerCell
            }
            else if indexPath.section == 1 && newFeaturesBool {
                if indexPath.row == 0 {
                headerCell.headerLabel.text = "New Features"
                    headerCell.counterLabel.text = "\(newFeaturesArray.count)"
                    return headerCell
                }
                else if indexPath.row > 0 {
                    contentCell.contentLabel.text = newFeaturesArray[indexPath.row - 1]
                    
                        return contentCell
                }
        }
        else if indexPath.section == 2 && !enhancementsBool {
            headerCell.headerLabel.text = "Enhancements"
            headerCell.counterLabel.text = "\(enhancementsArray.count)"
                return headerCell
            }
            else if indexPath.section == 2 && enhancementsBool {
                if indexPath.row == 0 {
                headerCell.headerLabel.text = "Enhancements"
                    headerCell.counterLabel.text = "\(enhancementsArray.count)"
                    return headerCell
                }
                else if indexPath.row > 0 {
                    contentCell.contentLabel.text = enhancementsArray[indexPath.row - 1]
                    
                        return contentCell
                }
        }
        
        let cell = UITableViewCell()
        cell.isHidden = true
        return cell
    }
}

