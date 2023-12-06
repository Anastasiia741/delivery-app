//  ProductCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit
import FirebaseStorage
import SDWebImage

protocol ProductCellDelegate: AnyObject {
    func priceButtonTapped(for product: Product)
}

final class ProductCell: UITableViewCell {
    //MARK: - ReuseId
    static let reuseId = ReuseId.productCell
    
    weak var delegate: ProductCellDelegate?
    
    //MARK: - Properties
    private var product: Product?

    //MARK: - UI
    private let nameLabel = MainTitleLabel(style: MainTitleType.product)
    private let detailLabel = DetaileLabel(style: DetaileLabelType.product)
    private let productImageView = ProductImageView(style: ProductImageType.menu)
    private let verticalStackView = StackView(style: .vertical)
    let priceButton: PriceButton = {
        let button = PriceButton(style: PriceButtonType.colorBackground)
        button.addTarget(nil, action: #selector(priceButtonTapped), for: .touchUpInside)
        button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        return button
    }()
    var isPriceButtonVisible = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Action
extension ProductCell {
    
    @objc func priceButtonTapped() {
        if let product = product {
            delegate?.priceButtonTapped(for: product)
            UIView.animate(withDuration: 0.1, animations: {
                self.priceButton.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
                self.priceButton.backgroundColor = UIColor(named: CollorBackground.priceButton)?.withAlphaComponent(0.7)
                self.priceButton.setTitleColor(.white, for: .normal)
            }) { (_) in
                UIView.animate(withDuration: 0.1) {
                    self.priceButton.transform = CGAffineTransform.identity
                    self.priceButton.backgroundColor = UIColor(named: CollorBackground.priceButton)?.withAlphaComponent(0.4)
                    self.priceButton.setTitleColor(.brown, for: .normal)
                }
            }
        }
    }
}

//MARK: - Business Logic
extension ProductCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
    }
    
    func update(withProduct product: Product) {
        
        if let productImage = product.image {
            let imageRef = Storage.storage().reference(forURL: productImage)
            imageRef.downloadURL { [weak self] url, error in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.productImageView.sd_setImage(with: url, placeholderImage: UIImage())
                }
            }
        }
        self.product = product
        nameLabel.text = product.name
        detailLabel.text = product.detail
        priceButton.setTitle("\(product.price) сом", for: .normal)
        priceButton.isHidden = !isPriceButtonVisible
    }
}

//MARK: - Layout
private extension ProductCell {
    
    func setupViews() {   
        contentView.addSubview(productImageView)
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(detailLabel)
        contentView.addSubview(priceButton)
    }
    
    func setupConstraints() {
        
        productImageView.snp.makeConstraints { make in
            make.left.top.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.left.equalTo(productImageView.snp.right).offset(16)
            make.right.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
        
        priceButton.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(16)
            make.right.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(35)
            make.width.equalTo(130)
        }
    }
}
