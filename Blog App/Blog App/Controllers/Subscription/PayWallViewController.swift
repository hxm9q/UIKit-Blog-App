//
//  PayWallViewController.swift
//  Blog App
//
//  Created by Антон Шадрин on 30.05.2025.
//

import UIKit

class PayWallViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let headerView = PayWallHeaderView()
    private let descriptionView = PayWallDescriptionView()
    
    private let subscribeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Subscribe", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore Purchases", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let termsTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "This is an auto-renewable Subscription. It will be charged to your iTunes account before each pay period. You can cancel anytime by going into your Settings > Subscriptions. Restore purchases if previously subscribed."
        textView.font = .systemFont(ofSize: 14)
        textView.textAlignment = .center
        textView.textColor = .secondaryLabel
        
        return textView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Blog App Premium"
        view.backgroundColor = .systemBackground
        
        setupNavigation()
        setupView()
        setupConstraints()
        setupActions()
    }
}

// MARK: - Setup Methods

private extension PayWallViewController {
    
    func setupNavigation() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didCloseButtonTapped)
        )
    }
    
    func setupView() {
        
        [headerView, descriptionView, subscribeButton, restoreButton, termsTextView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            descriptionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: subscribeButton.topAnchor),
            
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
            termsTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupActions() {
        
        subscribeButton.addTarget(self, action: #selector(didSubscribeButtonTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(didRestoreButtonTapped), for: .touchUpInside)
    }
}

// MARK: - Action Methods

private extension PayWallViewController {
    
    @objc func didCloseButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func didSubscribeButtonTapped() {
        
        subscribeButton.isEnabled = false
        subscribeButton.backgroundColor = .gray
        
        IAPManager.shared.fetchSubscriptionOptions { [weak self] _ in
            IAPManager.shared.subscribe { success in
                DispatchQueue.main.async {
                    self?.handleSubscriptionResult(success: success)
                }
            }
        }
    }
    
    @objc func didRestoreButtonTapped() {
        
        restoreButton.isEnabled = false
        
        IAPManager.shared.restorePurchases { [weak self] success in
            DispatchQueue.main.async {
                self?.handleRestorationResult(success: success)
            }
        }
    }
    
    private func handleSubscriptionResult(success: Bool) {
        
        subscribeButton.isEnabled = true
        subscribeButton.backgroundColor = .systemBlue
        
        if success {
            dismiss(animated: true)
        } else {
            showAlert(title: "Subscription failed",
                      message: "We were unable to complete the transaction.")
        }
    }
    
    private func handleRestorationResult(success: Bool) {
        
        restoreButton.isEnabled = true
        
        if success {
            dismiss(animated: true)
        } else {
            showAlert(title: "Restoration Failed",
                      message: "We were unable to restore a previous transaction.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
