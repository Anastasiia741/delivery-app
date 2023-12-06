//  CategoryCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 7/9/23.

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    static let reuseId = ReuseId.categoryCollectionCell
    private let containerView = ContainerView()
    private let nameLabel = MainTitleLabel(style: .menuTitle)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Business Logic
extension CategoryCollectionCell {
    
    func update(_ category: Category) {
        nameLabel.text = category.category.capitalized.lowercased()
    }
}

//MARK: - Layout
private extension CategoryCollectionCell {
    
    func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        nameLabel.textAlignment = .center
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
