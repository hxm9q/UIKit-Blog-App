//
//  CreateNewPostViewController.swift
//  Blog App
//
//  Created by  Антон Шадрин on 28.05.2025.
//

import UIKit

class CreateNewPostViewController: UITabBarController {
    
    // MARK: - Properties
    
    private var selectedHeaderImage: UIImage?
    
    // MARK: - UI Components
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .secondarySystemBackground
        textView.font = .systemFont(ofSize: 28)
        textView.dataDetectorTypes = [.link, .calendarEvent]
        
        return textView
    }()
    
    private let titleField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter title:"
        field.autocapitalizationType = .words
        field.autocorrectionType = .yes
        field.backgroundColor = .secondarySystemBackground
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 8
        field.clearButtonMode = .whileEditing
        
        
        return field
    }()
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupGestureRecognizer()
        setupLayout()
    }
    
    // MARK: - Setup UI
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(cancelTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post",
            style: .done,
            target: self,
            action: #selector(postTapped)
        )
    }
    
    private func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        headerImageView.addGestureRecognizer(tap)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc private func postTapped() {
        guard
            let title = titleField.text,
            let body = textView.text,
            let headerImage = selectedHeaderImage,
            let email = UserDefaults.standard.string(forKey: "email"),
            !title.trimmingCharacters(in: .whitespaces).isEmpty,
            !body.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            showAlert(title: "Oops", message: "Fields can't be empty.")
            return
        }
        
        let newPostId = UUID().uuidString
        
        // Upload Header Image
        StorageManager.shared.uploadBlogHeaderImage(
            email: email,
            image: headerImage,
            postId: newPostId
        ) { success in
            guard success else {
                return
            }
            
            StorageManager.shared.downloadUrlForPostHeader(email: email, postId: newPostId) { url in
                guard url != nil else {
                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .error)
                    }
                    return
                }
                
                // Insert of post into DB
                let post = BlogPost(
                    identifier: UUID().uuidString,
                    title: title,
                    timestamp: Date().timeIntervalSince1970,
                    headerImageUrl: nil,
                    text: body
                )
                
                DatabaseManager.shared.insert(blogPost: post, email: email) { [weak self] posted in
                    guard posted else {
                        DispatchQueue.main.async {
                            HapticsManager.shared.vibrate(for: .error)
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .success)
                        self?.cancelTapped()
                    }
                }
            }
        }
        
    }
    
    @objc private func headerTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - Setup Layout

private extension CreateNewPostViewController {
    
    func setupLayout() {
        
        [titleField, headerImageView, textView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            titleField.heightAnchor.constraint(equalToConstant: 50),
            
            headerImageView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 5),
            headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 160),
            
            textView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension CreateNewPostViewController:  UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        selectedHeaderImage = image
        headerImageView.image = image
    }
}

// MARK: - UITextViewDelegate

extension CreateNewPostViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= 200 // Максимум 200 символов
    }
}
