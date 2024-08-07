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
        
        let userDefaults = UserDefaults.standard
        let hasOnboarded = userDefaults.bool(forKey: "hasOnboarded")
        
        if let window = self.window {
            if hasOnboarded {
                window.rootViewController = UITabBarController.createConfiguredTabBarController()
            } else {
                let onboardingViewController = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil) as UIPageViewController
                window.rootViewController = onboardingViewController
            }
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
    
    func didFinishOnboarding() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "hasOnboarded")
        
        let tabBarController = UITabBarController.createConfiguredTabBarController()
        window?.rootViewController = tabBarController
    }
}

extension UITabBarController {
    static func createConfiguredTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let trackerViewController = TrackersViewController()
        trackerViewController.tabBarItem = UITabBarItem(title: Localizable.tabBarTrackers, image: UIImage(named: "circleIcon"), tag: 0)
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
        
        let statisticsViewController = UIViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: Localizable.tabBarStatistics, image: UIImage(named: "hareIcon"), tag: 1)
        
        tabBarController.viewControllers = [trackerNavigationController, statisticsViewController]
        return tabBarController
    }
}
