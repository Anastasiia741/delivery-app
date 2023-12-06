//  EditProductNameCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 11/10/23.

import UIKit

protocol EditProductNameDelegate: AnyObject {
    func didUpdateProductInfo(name: String, category: String, price: Int)
}

final class EditProductNameCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK: - ReuseId
    static let reuseId = ReuseId.editProductNameCell
    
    //MARK: - Properties
    var selectedProduct: Product?
    weak var delegate: EditProductNameDelegate?
    
    //MARK: - UI
    var nameTextField = ProfileTextField(style: .product)
    var categoryTextField = ProfileTextField(style: .category)
    var priceTextField =  ProfileTextField(style: .price)
    private let nameLabel = OrderDetailLabel(style: .productName)
    private let categoryLabel = OrderDetailLabel(style: .productCategory)
    private let priceLabel = OrderDetailLabel(style: .productPrice)
    private var verticalStackView = StackView(style: .vertical)
    
    //MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupStyles()
        setupAction()
        setupConstraints()
        updateProductDetail()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Navigation
extension EditProductNameCell {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            categoryTextField.becomeFirstResponder()
        } else if textField == categoryTextField {
            priceTextField.becomeFirstResponder()
        } else if textField == priceTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

//MARK: - Business Logic
extension EditProductNameCell {
    
    func updateProductDetail() {
        
        if let product = selectedProduct {
            nameTextField.text = product.name
            categoryTextField.text = product.category.lowercased()
            priceTextField.text = "\(product.price)"
        }
    }
    
    func setupAction() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        categoryTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        priceTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let name = nameTextField.text, let category = categoryTextField.text, let priceText = priceTextField.text, let price = Int(priceText) {
            delegate?.didUpdateProductInfo(name: name, category: category, price: price)
        }
    }
}

//MARK: - Layout
extension EditProductNameCell {
    
    func setupViews() {
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(nameTextField)
        verticalStackView.addArrangedSubview(categoryLabel)
        verticalStackView.addArrangedSubview(categoryTextField)
        verticalStackView.addArrangedSubview(priceLabel)
        verticalStackView.addArrangedSubview(priceTextField)
        
        nameTextField.delegate = self
        categoryTextField.delegate = self
        priceTextField.delegate = self
    }
    
    func setupStyles() {
        verticalStackView.distribution = .fill
    }
    
    func setupConstraints() {
        
        verticalStackView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(contentView).inset(20)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        categoryTextField.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        priceTextField.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
    }
}
