//  ProductImageCell.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 8/10/23.

import UIKit

class ProductImageCell: UICollectionViewCell {
    
    static let reuseID = ReuseId.productDetailCell

    let productImage = ProductImageView(style: ProductImageType.detail)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupStyles()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ProductImageCell {
    
    func setupView() {
         contentView.addSubview(productImage)
    }
    
    func setupStyles() {
    }
    
    func setupConstraints() {
       
        productImage.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView.safeAreaLayoutGuide).offset(20)
        }
    }
}
