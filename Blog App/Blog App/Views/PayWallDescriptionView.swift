//
//  PayWallDescriptionView.swift
//  Blog App
//
//  Created by  Антон Шадрин on 30.05.2025.
//

import UIKit

class PayWallDescriptionView: UIView {
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.numberOfLines = 0
        label.text = "Join Blog App Premium to read unlimited articles and browse thousands of posts."
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 1
        label.text = "$4.99 / month"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(descriptionLabel)
        addSubview(priceLabel)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PayWallDescriptionView {
    
    func setupLayout() {
        
        [descriptionLabel, priceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
