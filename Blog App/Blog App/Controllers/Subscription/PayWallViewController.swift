//
//  PayWallViewController.swift
//  Blog App
//
//  Created by  Антон Шадрин on 30.05.2025.
//

import UIKit

class PayWallViewController: UIViewController {
    
    private let headerView = PayWallHeaderView()
    
    private let descriptionView = PayWallDescriptionView()
    
    private let subscribeButton = UIButton(type: .system)
    private let restoreButton = UIButton(type: .system)
    
    private let termsTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Blog App Premium"
        view.backgroundColor = .systemBackground
        
        descriptionView.backgroundColor = .systemRed
        
        setupCloseButton()
        setupLayout()
        setupSubscriptionButtons()
        setupTerms()
    }
    
}

// MARK: - Setup Close Button
private extension PayWallViewController {
    
    func setupCloseButton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didCloseButtonTapped)
        )
    }
    
    @objc func didCloseButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setup Layout
private extension PayWallViewController {
    
    func setupLayout() {
        
        [headerView, subscribeButton, restoreButton, termsTextView, descriptionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            subscribeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subscribeButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            subscribeButton.widthAnchor.constraint(equalToConstant: 200),
            subscribeButton.heightAnchor.constraint(equalToConstant: 50),
            
            restoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restoreButton.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 20),
            
            termsTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            termsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            termsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            termsTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

// MARK: - Setup Subscription Buttons
private extension PayWallViewController {
    
    func setupSubscriptionButtons() {
        
        subscribeButton.setTitle("Subscribe", for: .normal)
        subscribeButton.setTitleColor(.white, for: .normal)
        subscribeButton.backgroundColor = .systemBlue
        subscribeButton.layer.cornerRadius = 10
        //        subscribeButton.addTarget(self, action: #selector(didSubscribeButtonTapped), for: .touchUpInside)
        
        restoreButton.setTitle("Restore Purchases", for: .normal)
        restoreButton.setTitleColor(.link, for: .normal)
        restoreButton.layer.cornerRadius = 10
        //        restoreButton.addTarget(self, action: #selector(didRestoreButtonTapped), for: .touchUpInside)
    }
    
    @objc func didSubscribeButtonTapped() {
        // Добавить реализацию в IAPManager.swift
    }
    
    @objc func didRestoreButtonTapped() {
        // Добавить реализацию в IAPManager.swift
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - Setup Terms of Service

private extension PayWallViewController {
    
    func setupTerms() {
        
        termsTextView.isEditable = false
        termsTextView.text = "This is an auto-renewable Subscription. It will be charged to your iTunes account before each pay period. You can cancel anytime by going into your Settings > Subscriptions. Restore purchases if previously subscribed."
        termsTextView.font = .systemFont(ofSize: 14)
        termsTextView.textAlignment = .center
        termsTextView.textColor = .secondaryLabel
    }
}
