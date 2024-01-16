//  ProductController.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 19/12/23.

import UIKit
import SnapKit
import FirebaseStorage
import SDWebImage

protocol ProductViewProtocol: AnyObject {
    func dismiss(animated: Bool)
    func showProductImage(url: URL)
    func showProduct(product: Product)
}

final class ProductController: UIViewController {
    public var presenter: ProductPresenter?

//  MARK: - UI
    private let scrollView = UIScrollView()
    private let productImage = ProductImageView(style: ProductImageType.detail)
    private let nameLabel = MainTitleLabel.init(style: .titleDetail)
    private var detailLabel = DetaileLabel(style: .detail)
    private var priceLabel = PriceLabel(style: PriceLabelType.price)
    private let verticalStackView = StackView(style: .verticalForProduct)
    private let orderView = OrderButtonView()
}

//  MARK: - Life Cycle
extension ProductController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
        setupActions()
        setupConstraints()
        presenter?.viewDidLoad()
    }
}

//  MARK: - Business Logic
extension ProductController: ProductViewProtocol {
    func showProductImage(url: URL) {
        productImage.sd_setImage(with: url, placeholderImage: UIImage())
    }
    
    func showProduct(product: Product) {
        self.nameLabel.text = product.name
        self.detailLabel.text = product.detail
        self.priceLabel.text = "\(product.price) сом"
    }
    
    func dismiss(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }
}

//  MARK: - Actions
private extension ProductController {
    
    func setupActions() {
        orderView.orderButton.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
    }
    
    @objc func orderButtonTapped() {
        presenter?.orderButtonTapped()
    }
}

//  MARK: - Layout
private extension ProductController {
    
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
            make.width.equalTo(Screen.width)
        }
        
        orderView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(0)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(-2)
        }
    }
}
