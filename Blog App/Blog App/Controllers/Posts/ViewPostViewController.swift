//
//  ViewPostViewController.swift
//  Blog App
//
//  Created by Антон Шадрин on 28.05.2025.
//

import UIKit

class ViewPostViewController: UITabBarController {
    
    // MARK: - Properties
    
    private let post: BlogPost
    private let isOwnedByCurrentUser: Bool
    
    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(PostHeaderTableViewCell.self,
                       forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        table.separatorStyle = .none
        table.estimatedRowHeight = 100
        table.rowHeight = UITableView.automaticDimension
        
        return table
    }()
    
    // MARK: - Init
    
    init(post: BlogPost, isOwnedByCurrentUser: Bool = false) {
        self.post = post
        self.isOwnedByCurrentUser = isOwnedByCurrentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - Setup Methods

private extension ViewPostViewController {
    
    func setupView() {
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource

extension ViewPostViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // title, image, text
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return createTitleCell(for: indexPath)
        case 1:
            return createImageCell(for: indexPath)
        case 2:
            return createTextCell(for: indexPath)
        default:
            fatalError("Unexpected index path")
        }
    }
    
    private func createTitleCell(for indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        cell.textLabel?.text = post.title
        
        return cell
    }
    
    private func createImageCell(for indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostHeaderTableViewCell.identifier,
            for: indexPath
        ) as? PostHeaderTableViewCell else {
            fatalError("Failed to dequeue PostHeaderTableViewCell")
        }
        
        cell.selectionStyle = .none
        cell.configure(with: .init(imageUrl: post.headerImageUrl))
        
        return cell
    }
    
    private func createTextCell(for indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = post.text
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewPostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0, 2:
            return UITableView.automaticDimension
        case 1:
            return 250
        default:
            return UITableView.automaticDimension
        }
    }
}
