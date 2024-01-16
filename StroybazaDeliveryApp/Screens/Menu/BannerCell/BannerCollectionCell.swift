//  CollectionViewCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit
import FirebaseStorage
import SDWebImage

final class BannerCollectionCell: UICollectionViewCell {
//  MARK: - ReuseId
    static var reuseId = ReuseId.bannerCellCollection
//  MARK: - Properties
    private var product: Product?
//  MARK: - UI
    private let nameLabel = MainTitleLabel(style: MainTitleType.promo)
    private let priceButton: PriceButton = {
        let button = PriceButton(style: PriceButtonType.noneBackground)
        button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        return button
    }()
    private let productImageView = ProductImageView(style: ProductImageType.cart)
    private let verticalStackView = StackView(style: .vertical)
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
   
//  MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//  MARK: - Business Logic
extension BannerCollectionCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
    }
    
    func update(_ product: Product) {
        if let productImage = product.image {
            let imageRef = Storage.storage().reference(forURL: productImage)
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.productImageView.sd_setImage(with: url, placeholderImage: UIImage())
                }
            }
        }
        self.product = product
        nameLabel.text = product.name
        priceButton.setTitle("\(product.price) сом", for: .normal)
    }
}

//  MARK: - Layout
private extension BannerCollectionCell {
    func setupView() {
        contentView.addSubview(containerView)
        containerView.addSubview(productImageView)
        containerView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(priceButton)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview().inset(4)
        }
        
        productImageView.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.left.equalTo(containerView).inset(8)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.right.top.bottom.equalTo(containerView.safeAreaLayoutGuide).inset(8)
            make.left.equalTo(productImageView.snp.right).offset(8)
        }
    }
}

