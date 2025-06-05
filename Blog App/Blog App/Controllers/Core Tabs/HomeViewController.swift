//
//  HomeViewController.swift
//  Blog App
//
//  Created by  Антон Шадрин on 28.05.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var posts: [BlogPost] = []
    
    // MARK: - UI Components
    
    private let composeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(
            systemName: "pencil.and.outline",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)),
                        for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            PostPreviewTableViewCell.self,
            forCellReuseIdentifier: PostPreviewTableViewCell.identifier
        )
        
        return tableView
    }()
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(composeButton)
        composeButton.addTarget(self, action: #selector(composeButtonTapped), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        composeButton.frame = CGRect(
            x: view.frame.width - 88,
            y: view.frame.height - 88 - view.safeAreaInsets.bottom,
            width: 60,
            height: 60
        )
        tableView.frame = view.bounds
    }
    
    // MARK: - Actions
    
    @objc private func composeButtonTapped() {
        let vc = CreateNewPostViewController()
        vc.title = "Create Post"
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    // MARK: - Data Fetching
    
    private func fetchAllPosts() {
        DatabaseManager.shared.getAllPosts { [weak self] posts in
            self?.posts = posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension HomeViewController: UITableViewDelegate & UITableViewDataSource {
    
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
        
        guard IAPManager.shared.canViewPost else {
            let vc = PayWallViewController()
            present(vc, animated: true, completion: nil)
            return
        }
        
        let vc = ViewPostViewController(post: posts[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }
}
