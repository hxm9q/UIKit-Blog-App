//
//  SignUpViewController.swift
//  Blog App
//
//  Created by Антон Шадрин on 28.05.2025.
//

import UIKit

class SignUpViewController: UITabBarController {
    
    // MARK: - UI Components
    
    private let headerView = SignInHeaderView()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Full Name"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.backgroundColor = .secondarySystemBackground
        field.returnKeyType = .next
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 8
        field.clearButtonMode = .whileEditing
        
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter your email here:"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.backgroundColor = .secondarySystemBackground
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 8
        field.clearButtonMode = .whileEditing
        
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter your password here:"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.backgroundColor = .secondarySystemBackground
        field.isSecureTextEntry = true
        field.returnKeyType = .done
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 8
        field.clearButtonMode = .whileEditing
        
        return field
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupActions()
    }
}

// MARK: - Setup Methods

private extension SignUpViewController {
    
    func setupView() {
        
        title = "Create Account"
        view.backgroundColor = .systemBackground
        
        [headerView, nameField, emailField, passwordField, signUpButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        nameField.becomeFirstResponder()
    }
    
    func setupConstraints() {
        
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
    
    func setupActions() {
        
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
}

// MARK: - Action Methods

private extension SignUpViewController {
    
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
                loadingIndicator.removeFromSuperview()
                let newUser = User(name: name, email: email, profilePictureRef: nil)
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

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
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
