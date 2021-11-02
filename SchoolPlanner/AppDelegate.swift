//
//  AppDelegate.swift
//  SchoolPlanner
//
//  Created by Cory Lowry on 9/19/21.
//

import UIKit
import CoreData
import GoogleMobileAds
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        application.applicationIconBadgeNumber = -1
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        //MARK: Authorization
            let center = UNUserNotificationCenter.current()
            
            
            //Delegate for UNUserNotificationCenterDelegate
            center.delegate = self
            
            //Permission for request alert, soud and badge
            center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                // Enable or disable features based on authorization.
                if(!granted){
                    print("not accept authorization")
                }else{
                    print("accept authorization")
                    
                    center.delegate = self
                    
                    
                }
            }
       
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "SchoolPlanner")
        container.persistentStoreDescriptions.forEach { storeDesc in
                    storeDesc.shouldMigrateStoreAutomatically = true
                    storeDesc.shouldInferMappingModelAutomatically = true
                }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in if let error = error as NSError? {
            
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
        })
        return container
    }()
    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

