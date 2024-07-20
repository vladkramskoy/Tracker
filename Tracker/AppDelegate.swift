//
//  AppDelegate.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 07.06.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        if let window = self.window {
            window.rootViewController = UITabBarController.createConfiguredTabBarController()
            window.makeKeyAndVisible()
            window.overrideUserInterfaceStyle = .light
        }
        
        return true
    }
    
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

extension UITabBarController {
    static func createConfiguredTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let trackerViewController = TrackersViewController()
        trackerViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "circleIcon"), tag: 0)
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
        
        let statisticsViewController = UIViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "hareIcon"), tag: 1)
        
        tabBarController.viewControllers = [trackerNavigationController, statisticsViewController]
        return tabBarController
    }
}
