//
//  ViewController.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/19/21.
//

import UIKit
import CoreData
import GoogleMobileAds

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var bannerView: GADBannerView! = GADBannerView(adSize: kGADAdSizeBanner)
    
    @IBOutlet weak var tableView: UITableView!
    
    var index: Int!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var classes: [Classes] {
        
        do {
            
            return try context.fetch(Classes.fetchRequest())
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Classes]()
        
    }
    
    var classNamePredicate: String!
    
    var assignments: [Assignments] {
        
        do {
            
            let fetchrequest = NSFetchRequest<Assignments>(entityName: "Assignments")
            let predicate = 0
            
            let now: Date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date = dateFormatter.string(from: now)
            let predicate2: NSPredicate = NSPredicate(format: "dueDate >= %@", date)
            let predicate1 = NSPredicate(format: "doneStatus == %d", predicate as CVarArg)
            let predicateClassName = NSPredicate(format: "assignmentClass == %@", classNamePredicate as CVarArg)
            let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate1, predicate2, predicateClassName])
            fetchrequest.predicate = andPredicate
            let sort = NSSortDescriptor(key: #keyPath(Assignments.dueDate), ascending: true)
            fetchrequest.sortDescriptors = [sort]
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Assignments]()
        
    }
    
    var pastDue: [Assignments] {
        
        do {
            let fetchrequest = NSFetchRequest<Assignments>(entityName: "Assignments")
            let predicate = 0
            
            let now: Date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date = dateFormatter.string(from: now)
            let predicate2: NSPredicate = NSPredicate(format: "dueDate < %@", date)
            let predicate1 = NSPredicate(format: "doneStatus == %d", predicate as CVarArg)
            let predicateClassName = NSPredicate(format: "assignmentClass == %@", classNamePredicate as CVarArg)
            let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate1, predicate2, predicateClassName])
            fetchrequest.predicate = andPredicate
            let sort = NSSortDescriptor(key: #keyPath(Assignments.dueDate), ascending: true)
            fetchrequest.sortDescriptors = [sort]
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Assignments]()
        
    }
    
    var doneAssignments: [Assignments] {
        
        do {
            
            let fetchrequest = NSFetchRequest<Assignments>(entityName: "Assignments")
            let predicate = 1
            let predicate1 = NSPredicate(format: "doneStatus == %d", predicate as CVarArg)
            let predicateClassName = NSPredicate(format: "assignmentClass == %@", classNamePredicate as CVarArg)
            let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate1, predicateClassName])
            fetchrequest.predicate = andPredicate
            let sort = NSSortDescriptor(key: #keyPath(Assignments.dueDate), ascending: false)
            fetchrequest.sortDescriptors = [sort]
            return try context.fetch(fetchrequest)
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        
        return [Assignments]()
        
    }
    
    var predicate: Int32!
    
    var grades: [Grades] {
        
        do {
            
            let fetchrequest = NSFetchRequest<Grades>(entityName: "Grades")
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
        // Do any additional setup after loading the view.
        
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-4546055219731501/4458073112"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let userDefaults = UserDefaults.standard
        
        if userDefaults.value(forKey: "appVersion") == nil || userDefaults.value(forKey: "appVersion") as? String != appVersion {
            tabBarController?.tabBar.items?[2].badgeValue = "1"
        }
        
        if UserDefaults.standard.value(forKey: "theme") == nil {
            UserDefaults.standard.set(2, forKey: "theme")
        }
        
        if UserDefaults.standard.value(forKey: "accent") == nil {
            UserDefaults.standard.set(0, forKey: "accent")
        }
        
        if UserDefaults.standard.value(forKey: "categoryBackground") == nil {
            UserDefaults.standard.set(0, forKey: "categoryBackground")
        }
        
        if UserDefaults.standard.value(forKey: "defaultCategory") == nil {
            UserDefaults.standard.set(2, forKey: "defaultCategory")
        }
        
        if UserDefaults.standard.value(forKey: "toggleNotifications") == nil {
            UserDefaults.standard.set(true, forKey: "toggleNotifications")
        }
        
        if UserDefaults.standard.value(forKey: "time") == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm"
            let time = dateFormatter.date(from: "07:30")
            UserDefaults.standard.set(time, forKey: "time")
        }
        
        if UserDefaults.standard.value(forKey: "hour") == nil {
            UserDefaults.standard.set(7, forKey: "hour")
        }
        
        if UserDefaults.standard.value(forKey: "minutes") == nil {
            UserDefaults.standard.set(30, forKey: "minutes")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        if userDefaults.integer(forKey: "theme") == 0 {
            view.window?.overrideUserInterfaceStyle = .light
        }
        else if userDefaults.integer(forKey: "theme") == 1 {
            view.window?.overrideUserInterfaceStyle = .dark
        }
        else if userDefaults.integer(forKey: "theme") == 2 {
            view.window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        noClassesStoredBackground()
        
        view.backgroundColor = tableView.backgroundColor
        let userDefaults = UserDefaults.standard
        if userDefaults.integer(forKey: "theme") == 0 {
            view.window?.overrideUserInterfaceStyle = .light
        }
        else if userDefaults.integer(forKey: "theme") == 1 {
            view.window?.overrideUserInterfaceStyle = .dark
        }
        else if userDefaults.integer(forKey: "theme") == 2 {
            view.window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = classes[indexPath.row].id
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(id, forKey: "id")
        performSegue(withIdentifier: "grades", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { (action, view, completionHandler) in
            let alert = UIAlertController(title: "Warning", message: "This will delete the class, all assignments for this class, and grades. Would you like to continue?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
                
                predicate = classes[indexPath.row].id
                classNamePredicate = classes[indexPath.row].name
                
                if assignments.count > 0 {
                    for i in 0...assignments.count - 1 {
                        let assignmentToDelete = assignments[i]
                        self.context.delete(assignmentToDelete)
                    }
                }
                if pastDue.count > 0 {
                    for i in 0...pastDue.count - 1 {
                        let assignmentToDelete = pastDue[i]
                      
                        self.context.delete(assignmentToDelete)
                    }
                }
                if doneAssignments.count > 0 {
                    for i in 0...doneAssignments.count - 1 {
                        let assignmentToDelete = doneAssignments[i]
                        self.context.delete(assignmentToDelete)
                    }
                }
                print("grades count is \(grades.count)")
                if grades.count > 0 {
                    for i in (0...grades.count - 1).reversed() {
                        let gradeToDelete = grades[i]
                     
                        self.context.delete(gradeToDelete)
                    }
                }
                print("grades count is \(grades.count)")
                if UserDefaults.standard.integer(forKey: "id") == predicate {
                    UserDefaults.standard.setValue(0, forKey: "id")
                }
                
                let classToDelete = self.classes[indexPath.row]
                self.context.delete(classToDelete)
                
                self.tableView.deleteRows(at: [indexPath], with: .left)
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                noClassesStoredBackground()
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
                tableView.setEditing(false, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { [self] (action, view, completionHandler) in
            
            index = Int(classes[indexPath.row].id)
            performSegue(withIdentifier: "editClass", sender: nil)
        }
        
        action.backgroundColor = .systemOrange
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
    func cellBackgroundColor(letter: String) -> UIColor {
        if letter == "A" || letter == "a" {
            return UIColor.magenta
        }
        else if letter == "B" || letter == "b" {
            return UIColor.cyan
        }
        else if letter == "C" || letter == "c" {
            return UIColor.systemTeal
        }
        else if letter == "D" || letter == "d" {
            return UIColor.systemOrange
        }
        else if letter == "E" || letter == "e" {
            return UIColor.systemRed
        }
        else if letter == "F" || letter == "f" {
            return UIColor.systemPink
        }
        else if letter == "G" || letter == "g" {
            return UIColor.systemPurple
        }
        else if letter == "H" || letter == "h" {
            return UIColor.systemYellow
        }
        else if letter == "I" || letter == "i" {
            return UIColor.systemBrown
        }
        else if letter == "J" || letter == "j" {
            return UIColor.gray
        }
        else if letter == "K" || letter == "k" {
            return UIColor.darkGray
        }
        else if letter == "L" || letter == "l" {
            return UIColor.magenta
        }
        if letter == "M" || letter == "m" {
            return UIColor.systemBlue
        }
        else if letter == "N" || letter == "n" {
            return UIColor.orange
        }
        else if letter == "O" || letter == "o" {
            return UIColor.init(rgb: 0x01D4C2)
        }
        else if letter == "P" || letter == "p" {
            return UIColor.init(rgb: 0x49B104)
        }
        else if letter == "Q" || letter == "q" {
            return UIColor.init(rgb: 0x3012C4)
        }
        else if letter == "R" || letter == "r" {
            return UIColor.init(rgb: 0x45AE76)
        }
        else if letter == "S" || letter == "s" {
            return UIColor.systemGreen
        }
        else if letter == "T" || letter == "t" {
            return UIColor.init(rgb: 0xECC693)
        }
        else if letter == "U" || letter == "u" {
            return UIColor.init(rgb: 0x4F5DEE)
        }
        else if letter == "V" || letter == "v" {
            return UIColor.init(rgb: 0x8210A8)
        }
        else if letter == "W" || letter == "w" {
            return UIColor.init(rgb: 0x760C05)
        }
        else if letter == "X" || letter == "x" {
            return UIColor.init(rgb: 0x4B696D)
        }
        else if letter == "Y" || letter == "y" {
            return UIColor.init(rgb: 0xEF66A5)
        }
        else {
            return UIColor.systemOrange
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if classes.count > 0 {
            let className = classes[indexPath.row]
            
            print("id is \(className.id)")
            
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
                
                text = "\(className.name!.prefix(1).uppercased())"
                print("no whitespace")
            }
            else {
                twoLetters = className.name!.split{$0 == " "}.map(String.init)
                let firstLetter = twoLetters[0].prefix(1)
                let secondLetter = twoLetters[1].prefix(1)
                text = "\(firstLetter.uppercased())\(secondLetter.uppercased())"
            }
            let letter = text.prefix(1)
            print("letter is \(letter)")
            lblNameInitialize.text = "\(text ?? "C") "
            lblNameInitialize.textAlignment = NSTextAlignment.center
            
            lblNameInitialize.backgroundColor = cellBackgroundColor(letter: String(letter.uppercased()))
            
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
    
    func noClassesStoredBackground() {
        if classes.count == 0 {
            
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.accessibilityFrame.size.width, height: self.accessibilityFrame.size.height))
            messageLabel.text = "There are currently no classes stored. Hit the + to add one."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel;
            
            tableView.separatorStyle = .none;
        }
        else {
            tableView.backgroundView = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editClass" {
            let dvc = segue.destination as! AddClassViewContrller
            dvc.editClass = 1
            dvc.selectedIndex = index
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}
