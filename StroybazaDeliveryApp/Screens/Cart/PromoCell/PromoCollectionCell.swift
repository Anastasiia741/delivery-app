//  PromoCollectionCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit
import FirebaseStorage
import SDWebImage

final class PromoCollectionCell: UICollectionViewCell {
    
    //MARK: - ReuseId
    static var reuseId = ReuseId.promoCollectionCell
    
    //MARK: - Properties
    private var product: Product?
    
    //MARK: - UI
    private let nameLabel = MainTitleLabel(style: MainTitleType.promo)
    private let priceButton = PriceButton(style: PriceButtonType.cartButton)
    private let productImage = ProductImageView(style: ProductImageType.cart)
    private let verticalStackView = StackView(style: .verticalForPromo)
    
    //MARK: - Life Curcle
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

//MARK: - Business Logic
extension PromoCollectionCell {
    
    func update(_ product: Product) {
        
        if let productImage = product.image {
            let imageRef = Storage.storage().reference(forURL: productImage)
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.productImage.sd_setImage(with: url, placeholderImage: UIImage())
                }
            }
        }
        
        self.product = product
        nameLabel.text = product.name
        priceButton.setTitle("\(product.price) сом", for: .normal)
    }
}

//MARK: - Layout
private extension PromoCollectionCell {
    
    private func setupView() {
        
        contentView.addSubview(productImage)
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(priceButton)
    }
    
    private func setupStyles() {
        
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
    }
    
    private func setupConstraints() {
        
        productImage.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.left.equalTo(contentView.snp.left).inset(10)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.right.top.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.left.equalTo(productImage.snp.right).offset(10)
        }
    }
}
