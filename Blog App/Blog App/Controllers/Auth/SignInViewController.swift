//
//  SignInViewController.swift
//  Blog App
//
//  Created by  Антон Шадрин on 28.05.2025.
//

import UIKit

class SignInViewController: UITabBarController {
    
    private let headerView = SignInHeaderView()
    
    private let emailField = UITextField()
    private let passwordField = UITextField()
    
    private let signInButton = UIButton(type: .system)
    
    private let createAccountButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        
        setupLayout()
        setupTextFields()
        setupButtons()
        
    }
    
}

// MARK: - Setup Layout
private extension SignInViewController {
    
    func setupLayout() {
        
        [headerView, emailField, passwordField, signInButton, createAccountButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 48),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordField.heightAnchor.constraint(equalToConstant: 48),
            
            signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            
            createAccountButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            createAccountButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

// MARK: - Setup Text Fields
extension SignInViewController: UITextFieldDelegate {
    
    private func setupTextFields() {
        
        emailField.placeholder = "Enter your email here:"
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.backgroundColor = .secondarySystemBackground
        emailField.keyboardType = .emailAddress
        emailField.returnKeyType = .next
        emailField.borderStyle = .roundedRect
        emailField.layer.cornerRadius = 8
        emailField.clearButtonMode = .whileEditing
        emailField.delegate = self
        
        passwordField.placeholder = "Enter your password here:"
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.backgroundColor = .secondarySystemBackground
        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .done
        passwordField.borderStyle = .roundedRect
        passwordField.layer.cornerRadius = 8
        passwordField.clearButtonMode = .whileEditing
        passwordField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            passwordField.resignFirstResponder()
            // Логика входа
        }
        
        return true
    }
    
}

// MARK: - Setup Buttons
private extension SignInViewController {
    
    func setupButtons() {
        
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = .systemBlue
        signInButton.layer.cornerRadius = 8
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        createAccountButton.setTitle("Create Account", for: .normal)
        createAccountButton.setTitleColor(.link, for: .normal)
        createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
    }
    
    @objc func signInButtonTapped() {
        guard
            let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty
        else {
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "Error", message: "Please enter a valid email address")
            return
        }
        
        AuthManager.shared.signIn(email: email, password: password) { [weak self] success in
            guard success else {
                return
            }
            
            DispatchQueue.main.async {
                UserDefaults.standard.set(email, forKey: "email")
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }
        }
    }
    
    @objc func createAccountButtonTapped() {
        let vc = SignUpViewController()
        vc.title = "Create Account"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
