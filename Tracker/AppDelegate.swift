//
//  AppDelegate.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 07.06.2024.
//

import UIKit
import CoreData
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private let userDefaults = UserDefaults.standard
    
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
        
        let hasOnboarded = userDefaults.bool(forKey: "hasOnboarded")
        let pinnedCategoryHasBeenAdded = userDefaults.bool(forKey: "pinnedCategoryHasBeenAdded")
        
        if let window = self.window {
            if hasOnboarded {
                window.rootViewController = UITabBarController.createConfiguredTabBarController()
            } else {
                let onboardingViewController = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil) as UIPageViewController
                window.rootViewController = onboardingViewController
            }
            window.makeKeyAndVisible()
        }
        
        if !pinnedCategoryHasBeenAdded {
            addPinnedCategory()
        }
        
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: Constants.yandexMetricaApiKey) else {
            return true
        }
        YMMYandexMetrica.activate(with: configuration)
        
        UserDefaults.standard.set(1, forKey: "selectedFilter")
        
        let categoryManager = CategoryManager()
        categoryManager.addPinnedCategoryNeeded()
        
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
        userDefaults.set(true, forKey: "hasOnboarded")
        
        let tabBarController = UITabBarController.createConfiguredTabBarController()
        window?.rootViewController = tabBarController
    }
    
    private func addPinnedCategory() {
        userDefaults.set(true, forKey: "pinnedCategoryHasBeenAdded")
        
        let trackerCategoryStore = TrackerCategoryStore()
        let pinnedCetgory = TrackerCategory(name: "Закрепленные", trackers: [])
        TrackersViewController.categories.insert(pinnedCetgory, at: 0)
        
        do {
            try trackerCategoryStore.addNewCategory(pinnedCetgory)
        } catch {
            print("Error adding a category to the database")
        }

    }
}

extension UITabBarController {
    static func createConfiguredTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let trackerViewController = TrackersViewController()
        trackerViewController.tabBarItem = UITabBarItem(title: Localizable.tabBarTrackers, image: UIImage(named: "circleIcon"), tag: 0)
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: Localizable.tabBarStatistics, image: UIImage(named: "hareIcon"), tag: 1)
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        
        tabBarController.viewControllers = [trackerNavigationController, statisticsNavigationController]
        return tabBarController
    }
}
