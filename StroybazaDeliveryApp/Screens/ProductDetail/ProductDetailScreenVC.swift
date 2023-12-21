//  ViewController.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit
import FirebaseStorage
import SDWebImage

final class ProductDetailScreenVC: UIViewController{
    
//  MARK: - Actions
    var selectedProduct: Product?
//  MARK: - Properties
    private let orderService = OrderService()
//  MARK: - UI
    private let scrollView = UIScrollView()
    private let verticalStackView = StackView(style: .verticalForProduct)
    private let orderView = OrderButtonView()
    private var productImage = ProductImageView(style: ProductImageType.detail)
    private let nameLabel = MainTitleLabel.init(style: .titleDetail)
    private let detailLabel = DetaileLabel(style: .detail)
    private let priceLabel = PriceLabel(style: PriceLabelType.price)
        
//  MARK: - Life Cucle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
        setupActions()
        setupConstraints()
        
        updateImageDetail()
        updateProductDetail()
    }
}

//  MARK: - Business Logic
private extension ProductDetailScreenVC {
    func updateImageDetail() {
        if let product = selectedProduct {
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
        }
    }
    
    func updateProductDetail() {
        if let product = selectedProduct {
            nameLabel.text = product.name
            detailLabel.text = product.description
            priceLabel.text = "\(product.price) сом"
        }
    }
}

//  MARK: - Actions
private extension ProductDetailScreenVC {
        
    func setupActions() {
        orderView.orderButton.addTarget(self, action: #selector(oderButtonTapped), for: .touchUpInside)
    }
    
    @objc func oderButtonTapped() {
        let _ = orderService.addProduct(selectedProduct)
        dismiss(animated: true)
    }
}

//  MARK: - Layout
private extension ProductDetailScreenVC {
    
    func setupViews() {
        view.addSubview(scrollView)
        view.addSubview(orderView)
        scrollView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(productImage)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(detailLabel)
        verticalStackView.addArrangedSubview(priceLabel)
    }
    
    func setupStyles() {
        view.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        verticalStackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        verticalStackView.isLayoutMarginsRelativeArrangement = true
        
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.left.top.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(scrollView)
            make.top.equalTo(scrollView).inset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            
        }
        
        detailLabel.snp.makeConstraints { make in
            make.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        orderView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(0)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(-2)
        }
        
        
    }
}


