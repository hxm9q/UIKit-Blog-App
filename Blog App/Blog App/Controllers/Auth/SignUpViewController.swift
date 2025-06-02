//
//  SignUpViewController.swift
//  Blog App
//
//  Created by  Антон Шадрин on 28.05.2025.
//

import UIKit

class SignUpViewController: UITabBarController {
    
    private let headerView = SignInHeaderView()
    
    private let nameField = UITextField()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    
    private let signUpButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        
        setupLayout()
        setupTextFields()
        setupButton()
    }
    
}

// MARK: - Setup Layout
private extension SignUpViewController {
    
    func setupLayout() {
        
        [nameField, headerView, emailField, passwordField, signUpButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameField.heightAnchor.constraint(equalToConstant: 48),
            
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 48),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordField.heightAnchor.constraint(equalToConstant: 48),
            
            signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            signUpButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

// MARK: - Setup Text Fields & Delegate
extension SignUpViewController: UITextFieldDelegate {
    
    private func setupTextFields() {
        
        nameField.placeholder = "Full Name"
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        nameField.backgroundColor = .secondarySystemBackground
        nameField.returnKeyType = .next
        nameField.borderStyle = .roundedRect
        nameField.layer.cornerRadius = 8
        nameField.clearButtonMode = .whileEditing
        nameField.delegate = self
        
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
        
        nameField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            emailField.becomeFirstResponder()
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            passwordField.resignFirstResponder()
            signUpButtonTapped()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}

// MARK: - Setup Buttons
private extension SignUpViewController {
    
    func setupButton() {
        
        signUpButton.setTitle("Create Account", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = .systemGreen
        signUpButton.layer.cornerRadius = 8
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func signUpButtonTapped() {
        
        guard
            let name = nameField.text, !name.isEmpty,
            let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty
        else {
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "Error", message: "Please enter a valid email address")
            return
        }
        
        guard password.count >= 6 else {
            showAlert(title: "Error", message: "Password must be at least 6 characters")
            return
        }
        
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.startAnimating()
        signUpButton.addSubview(loadingIndicator)
        loadingIndicator.center = CGPoint(x: signUpButton.bounds.width/2, y: signUpButton.bounds.height/2)
        signUpButton.isEnabled = false
        
        AuthManager.shared.signUp(email: email, password: password) { [weak self] success in
            if success {
                loadingIndicator.removeFromSuperview() // убрать если что
                let newUser = User(name: name, email: email, profilePictureURL: nil)
                DatabaseManager.shared.insert(user: newUser) { inserted in
                    guard inserted else {
                        return
                    }
                    
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(name, forKey: "name")
                    
                    DispatchQueue.main.async {
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)
                    }
                }
            } else {
                self?.showAlert(title: "Error", message: "Failed to create account")
            }
        }
        
    }
    
}
