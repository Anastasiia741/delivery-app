//  CartCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit
import FirebaseStorage

final class CartCell: UITableViewCell {
    
    //MARK: - reuseId
    static let reuseId = ReuseId.cartCell
    
    //MARK: - Properties
    private var product: Product?
    
    //MARK: - UI
    private let productImageView = ProductImageView(style: ProductImageType.cart)
    private let nameLabel = MainTitleLabel(style: MainTitleType.cartTitle)
    private let priceLabel = PriceLabel(style: PriceLabelType.product)
    private let horizontalStackView = StackView(style: .horizontal)
    private let stepperView = CustomStepper()
    private let stepperContainerView = UIView ()
    var onProductChanged: ((Product, Int)->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        setupStepper()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Business Logic
extension CartCell {
    
    func update(_ product: Product) {
        
        self.product = product
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
        
        nameLabel.text = product.name
        priceLabel.text = "\(product.price) сом"
        stepperView.currentValue = product.quantity
    }
    
    @objc func stepperChangedValueAction(sender: CustomStepper) {
        
        guard let product = self.product else { return }
        onProductChanged?(product, sender.currentValue)
    }
    
}

//MARK: - Layout
private extension CartCell {
    
    func setupViews() {
        
        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(priceLabel)
        horizontalStackView.addArrangedSubview(stepperContainerView)
        stepperContainerView.addSubview(stepperView)
    }
    
    func setupConstraints() {
        
        productImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.top.equalTo(contentView).offset(10)
            make.bottom.lessThanOrEqualTo(contentView).offset(-8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.right.equalTo(contentView).offset(10)
            make.left.equalTo(productImageView.snp.right).offset(12)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(40)
            make.left.equalTo(productImageView.snp.right).offset(12)
            make.right.equalTo(contentView).offset(-16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(horizontalStackView)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
        
        stepperContainerView.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(30)
            stepperView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func setupStepper() {
        stepperView.addTarget(self, action: #selector(stepperChangedValueAction), for: .valueChanged)
    }
}

