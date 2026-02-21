//
//  AppDelegate.swift
//  BrainMaps_Explorer
//
//  Created by Fariha Kha on 11/08/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Apply basic colors
        applyBasicColors()
        
        // Create Tab Bar Controller
        let tabBarController = UITabBarController()
        
        // Create Search Screen
        let searchVC = SearchViewController()
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        // Create Favorites Screen
        let favoritesVC = FavoritesViewController()
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 1)
        
        // Add to Tab Bar
        tabBarController.viewControllers = [searchNav, favoritesNav]
        
        // Set colors on tab bar
        tabBarController.tabBar.tintColor = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
        tabBarController.tabBar.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 251/255, alpha: 1.0)
        
        // Set as root
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func applyBasicColors() {
        // Use direct RGB values
        let pinkColor = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
        let charcoalColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
        
        // Navigation Bar
        UINavigationBar.appearance().tintColor = pinkColor
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: charcoalColor,
            .font: UIFont(name: "Optima-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
    }
    
}
