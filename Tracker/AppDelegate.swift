//
//  AppDelegate.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 07.06.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        if let window = self.window {
            window.rootViewController = UITabBarController.createConfiguredTabBarController()
            window.makeKeyAndVisible()
            window.overrideUserInterfaceStyle = .light
        }
        
        return true
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
