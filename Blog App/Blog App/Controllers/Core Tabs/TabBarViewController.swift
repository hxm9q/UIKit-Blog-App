//
//  TabBarViewController.swift
//  Blog App
//
//  Created by  Антон Шадрин on 28.05.2025.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
    }
    
}

// MARK: - Setup Controllers
private extension TabBarViewController {
    
    func setupControllers() {
        
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "email") else {
            AuthManager.shared.signOut { _ in
                // do nothing
            }
            return
        }
        
        let home = HomeViewController()
        let profile = ProfileViewController(currentEmail: currentUserEmail)
        
        home.title = "Home"
        home.navigationItem.largeTitleDisplayMode = .always
        
        profile.title = "Profile"
        profile.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: profile)
        let navControllers = [nav1, nav2]
        
        navControllers.forEach { $0.navigationBar.prefersLargeTitles = true }
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle.fill"), tag: 2)
        
        setViewControllers(navControllers, animated: true)
    }
}
