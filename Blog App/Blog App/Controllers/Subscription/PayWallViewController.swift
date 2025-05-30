//
//  PayWallViewController.swift
//  Blog App
//
//  Created by  Антон Шадрин on 30.05.2025.
//

import UIKit

class PayWallViewController: UIViewController {
    
    private let header = PayWallHeaderView()
    
    private let subscribeButton = UIButton(type: .system)
    private let restoreButton = UIButton(type: .system)
    
    private let termsTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Blog App Premium"
        view.backgroundColor = .systemBackground
        
        setupCloseButton()
        embedViews()
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

// MARK: - Embed Views
private extension PayWallViewController {
    
    func embedViews() {
        
        [header, subscribeButton, restoreButton, termsTextView].forEach {
            view.addSubview($0)
        }
    }
}

// MARK: - Setup Layout
private extension PayWallViewController {
    
    func setupLayout() {
        
        [header, subscribeButton, restoreButton, termsTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
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
        //        restoreButton.backgroundColor = .systemBlue
        restoreButton.layer.cornerRadius = 10
        //        restoreButton.addTarget(self, action: #selector(didRestoreButtonTapped), for: .touchUpInside)
    }
    
    @objc func didSubscribeButtonTapped() {
        // Добавить реализацию в IAPManager.swift
    }
    
    @objc func didRestoreButtonTapped() {
        // Добавить реализацию в IAPManager.swift
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
