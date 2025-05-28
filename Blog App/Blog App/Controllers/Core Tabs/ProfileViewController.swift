//
//  ProfileViewController.swift
//  Blog App
//
//  Created by  Антон Шадрин on 28.05.2025.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign Out",
            style: .done,
            target: self,
            action: #selector(didSignOutTapped)
        )
        
        
    }
    
}

// MARK: -
private extension ProfileViewController {
    
    @objc func didSignOutTapped() {
        
    }
}
