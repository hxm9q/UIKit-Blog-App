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
            
            subscribeButton.bottomAnchor.constraint(equalTo: restoreButton.topAnchor, constant: -10),
            subscribeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            subscribeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            subscribeButton.heightAnchor.constraint(equalToConstant: 50),
            
            restoreButton.bottomAnchor.constraint(equalTo: termsTextView.topAnchor, constant: -70),
            restoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            restoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            restoreButton.heightAnchor.constraint(equalToConstant: 50),
            
            termsTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            termsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            termsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            termsTextView.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: subscribeButton.topAnchor)
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
        subscribeButton.addTarget(self, action: #selector(didSubscribeButtonTapped), for: .touchUpInside)
        
        restoreButton.setTitle("Restore Purchases", for: .normal)
        restoreButton.setTitleColor(.link, for: .normal)
        restoreButton.layer.cornerRadius = 10
        restoreButton.addTarget(self, action: #selector(didRestoreButtonTapped), for: .touchUpInside)
    }
    
    @objc func didSubscribeButtonTapped() {
        subscribeButton.isEnabled = false
        subscribeButton.backgroundColor = .gray
        
        IAPManager.shared.fetchSubscriptionOptions { [weak self] _ in
            IAPManager.shared.subscribe { success in
                DispatchQueue.main.async {
                    self?.subscribeButton.isEnabled = true
                    self?.subscribeButton.backgroundColor = .systemBlue
                    
                    if success {
                        self?.dismiss(animated: true)
                    } else {
                        self?.showAlert(title: "Subscription failed",
                                        message: "We were unable to complete the transaction.")
                    }
                }
            }
        }
    }
    
    @objc func didRestoreButtonTapped() {
        restoreButton.isEnabled = false
        
        IAPManager.shared.restorePurchases { [weak self] success in
            DispatchQueue.main.async {
                self?.restoreButton.isEnabled = true
                
                if success {
                    self?.dismiss(animated: true)
                } else {
                    self?.showAlert(title: "Restoration Failed",
                                    message: "We were unable to restore a previous transaction.")
                }
            }
        }
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
