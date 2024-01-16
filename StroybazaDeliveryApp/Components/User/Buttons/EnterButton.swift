//  enterButton.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 3/8/23.

import UIKit

enum EnterButtomType {
    case authorization, registration
}

final class EnterButtom: UIButton {
    
    init(style: EnterButtomType) {
        super.init(frame: .zero)
        commonInit(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(style: EnterButtomType) {
        
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        self.layer.cornerRadius = 12
        
        switch style {
        case .authorization:
            self.setTitle("Войти", for: .normal)
            self.setTitleColor(.black, for: .normal)
            self.backgroundColor = .authButton
        case .registration:
            self.setTitle("Регистрация", for: .normal)
            self.setTitleColor(.systemBrown, for: .normal)
        }
    }
}
