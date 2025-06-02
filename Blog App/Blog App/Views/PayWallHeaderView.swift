//
//  PayWallHeaderView.swift
//  Blog App
//
//  Created by  Антон Шадрин on 30.05.2025.
//

import UIKit

class PayWallHeaderView: UIView {
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "crown.fill"))
        imageView.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
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
private extension PayWallHeaderView {
    
    func setupLayout() {
        
        addSubview(headerImageView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerImageView.widthAnchor.constraint(equalToConstant: 110),
            headerImageView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
}
