//
//  SignInHeaderView.swift
//  Blog App
//
//  Created by  Антон Шадрин on 02.06.2025.
//

import UIKit

class SignInHeaderView: UIView {
    
    // MARK: - UI Components
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let signInLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.text = "Explore millions of posts!"
        
        return label
    } ()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Layout
private extension SignInHeaderView {
    
    func setupLayout() {
        
        [headerImageView, signInLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            headerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerImageView.widthAnchor.constraint(equalToConstant: 110),
            headerImageView.heightAnchor.constraint(equalToConstant: 110),
            
            signInLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 15),
            signInLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            signInLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            signInLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
