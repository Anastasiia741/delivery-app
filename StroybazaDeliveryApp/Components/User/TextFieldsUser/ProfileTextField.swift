//  ProfileTextFields.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit

enum ProfileTextFieldType {
    case name, number, email, address, product, price, category
}

final class ProfileTextField: UITextField {
    
    init(style: ProfileTextFieldType) {
        super.init(frame: .zero)
        commonInit(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(_ style: ProfileTextFieldType) {
        self.font = UIFont.systemFont(ofSize: 17)
        self.returnKeyType = .done
        
        switch style {
        case .name:
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black]
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray]
            let placeholderText = "Ваше имя"
            let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
            self.attributedPlaceholder = attributedPlaceholder
            self.backgroundColor = .none
            padding()
        case .number:
            self.placeholder = "Номер телефона"
            self.text = "+996 "
            self.keyboardType = .phonePad
            padding()
        case .email:
            self.placeholder = "Email"
        case .address:
            self.placeholder = "Введите адрес"
            self.font = UIFont.systemFont(ofSize: 18)
            self.returnKeyType = .next
        case .product:
            self.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            self.placeholder = "Название товара"
            self.backgroundColor = .systemGray5.withAlphaComponent(0.5)
            self.textColor = UIColor.lightGray
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.priceButton?.cgColor
            self.returnKeyType = .next
            padding()
        case .price:
            self.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            self.placeholder = "Цена"
            self.keyboardType = .decimalPad
            self.backgroundColor = .systemGray5.withAlphaComponent(0.5)
            self.textColor = UIColor.lightGray
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.priceButton?.cgColor
            self.returnKeyType = .next
            padding()
        case .category:
            self.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            self.placeholder = "Категория"
            self.backgroundColor = .systemGray5.withAlphaComponent(0.5)
            self.textColor = UIColor.lightGray
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.priceButton?.cgColor
            self.returnKeyType = .next
            padding()
        }
    }
    
    func padding() {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always
        self.layer.cornerRadius = 5.0
    }
    
}

extension ProfileTextField: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
