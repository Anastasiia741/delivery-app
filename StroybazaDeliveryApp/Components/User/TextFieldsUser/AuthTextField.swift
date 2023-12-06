//  AuthTextField.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 3/8/23.

import UIKit

enum AuthTextFieldType {
    case email, password, confirmPassword
}

final class AuthTextField: UITextField {
    
    init(style: AuthTextFieldType) {
        super.init(frame: .zero)
        commonInit(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(_ style: AuthTextFieldType) {
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        self.backgroundColor = UIColor(named: "WhiteAlpha")
        self.layer.cornerRadius = 12
        self.returnKeyType = .next
        switch style {
        case .email:
            self.placeholder = "Введите email"
            self.returnKeyType = .next
        case .password:
            self.placeholder = "Введите пароль"
            self.isSecureTextEntry = true
            self.returnKeyType = .next
        case .confirmPassword:
            self.placeholder = "Повторите пароль"
            self.isSecureTextEntry = true
            self.returnKeyType = .next
        }
    }
}

extension AuthTextField: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
