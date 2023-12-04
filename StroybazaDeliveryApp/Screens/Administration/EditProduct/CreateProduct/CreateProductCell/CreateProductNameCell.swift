//  CreateProductNameCell.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 10/10/23.

import UIKit

protocol CreateProductNameDelegate: AnyObject {
    func didUpdateProductInfo(_ name: String, _ category: String, _ prise: String)
}


final class CreateProductNameCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK: - ReuseId
    static let reuseId = ReuseId.createProductNameCell
    
    //MARK: - UI
    private var verticalStackView = StackView(style: .vertical)
    private let nameTextField = ProfileTextField(style: .product)
    private let categoryTextField = ProfileTextField(style: .category)
    private let priceTextField = ProfileTextField(style: .price)
    
    //MARK: - Propertise
    weak var delegate: CreateProductNameDelegate?
    
    //MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupAction()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Navigation
extension CreateProductNameCell {
    
    func setupAction() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        categoryTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        priceTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
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

//MARK: - Delegate
extension CreateProductNameCell {
    
    func clearNameTextField() {
        nameTextField.text = ""
        categoryTextField.text = ""
        priceTextField.text = ""
    }
        
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let name = nameTextField.text, let category = categoryTextField.text, let price = priceTextField.text {
            delegate?.didUpdateProductInfo(name, category.lowercased(), price)
        }
    }
    
}

//MARK: - Layout
private extension CreateProductNameCell {
    
    func setupViews() {
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameTextField)
        verticalStackView.addArrangedSubview(categoryTextField)
        verticalStackView.addArrangedSubview(priceTextField)
        
        nameTextField.delegate = self
        categoryTextField.delegate = self
        priceTextField.delegate = self
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
