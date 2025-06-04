//
//  ProfileViewController.swift
//  Blog App
//
//  Created by Антон Шадрин on 28.05.2025.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Properties

    private var user: User?
    private var posts: [BlogPost] = []
    private let tableView = UITableView()
    let currentEmail: String

    // MARK: - Init

    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSignOutButton()
        setUpTable()
        title = "Profile"
        fetchPosts()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    // MARK: - Setup UI

    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            PostPreviewTableViewCell.self,
            forCellReuseIdentifier: PostPreviewTableViewCell.identifier
        )
        setUpTableHeader()
        fetchProfileData()
    }

    private func setUpTableHeader(profilePhotoRef: String? = nil, name: String? = nil) {
        let headerView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: view.width / 1.5
        ))
        headerView.backgroundColor = .systemBlue
        headerView.isUserInteractionEnabled = true
        headerView.clipsToBounds = true
        tableView.tableHeaderView = headerView

        // Profile picture
        let profilePhoto = UIImageView(image: UIImage(systemName: "person.circle"))
        profilePhoto.tintColor = .white
        profilePhoto.contentMode = .scaleAspectFit
        profilePhoto.frame = CGRect(
            x: (view.width - (view.width / 4)) / 2,
            y: (headerView.height - (view.width / 4)) / 2.5,
            width: view.width / 4,
            height: view.width / 4
        )
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.width / 2
        profilePhoto.isUserInteractionEnabled = true
        headerView.addSubview(profilePhoto)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
        profilePhoto.addGestureRecognizer(tap)

        // Email label
        let emailLabel = UILabel(frame: CGRect(
            x: 20,
            y: profilePhoto.bottom + 10,
            width: view.width - 40,
            height: 100
        ))
        headerView.addSubview(emailLabel)
        emailLabel.text = currentEmail
        emailLabel.textAlignment = .center
        emailLabel.textColor = .white
        emailLabel.font = .systemFont(ofSize: 25, weight: .bold)

        if let name = name {
            title = name
        }

        if let ref = profilePhotoRef {
            StorageManager.shared.downloadProfileImage(email: ref) { image in
                DispatchQueue.main.async {
                    profilePhoto.image = image ?? UIImage(systemName: "person.circle")
                }
            }
        }
    }

    private func setUpSignOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign Out",
            style: .done,
            target: self,
            action: #selector(didTapSignOut)
        )
    }

    // MARK: - Actions

    @objc private func didTapProfilePhoto() {
        guard
            let myEmail = UserDefaults.standard.string(forKey: "email"),
            myEmail == currentEmail
        else {
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    @objc private func didTapSignOut() {
        let alert = UIAlertController(
            title: "Sign Out",
            message: "Are you sure?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "name")
                        
                        let signInVC = SignInViewController()
                        signInVC.navigationItem.largeTitleDisplayMode = .always
                        
                        let navVC = UINavigationController(rootViewController: signInVC)
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true, completion: nil)
                    }
                }
            }
        }))
        present(alert, animated: true)
    }

    // MARK: - Data Fetching

    private func fetchProfileData() {
        DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {
                return
            }
            self?.user = user
            
            DispatchQueue.main.async {
                self?.setUpTableHeader(
                    profilePhotoRef: user.profilePictureRef,
                    name: user.name
                )
            }
        }
    }
    
    private func fetchPosts() {
        DatabaseManager.shared.getPosts(for: currentEmail) { [weak self] posts in
            self?.posts = posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostPreviewTableViewCell.identifier,
            for: indexPath
        ) as? PostPreviewTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        
        let isOwnedByCurrentUser = UserDefaults.standard.string(forKey: "email") == currentEmail
        let post = posts[indexPath.row]
        
        let vc = ViewPostViewController(
            post: post,
            isOwnedByCurrentUser: isOwnedByCurrentUser
        )
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        StorageManager.shared.uploadUserProfilePicture(
            email: currentEmail,
            image: image
        ) { [weak self] success in
            guard let self = self else { return }
            
            if success {
                DispatchQueue.main.async {
                    self.fetchProfileData()
                    
                    HapticsManager.shared.vibrate(for: .success)
                    let alert = UIAlertController(
                        title: "Успешно!",
                        message: "Фото профиля обновлено",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    HapticsManager.shared.vibrate(for: .error)
                    let alert = UIAlertController(
                        title: "Ошибка",
                        message: "Не удалось обновить фото профиля",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
