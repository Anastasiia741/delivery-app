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
            self.backgroundColor = UIColor(named: "AuthButtonRed")
            
            let gradientLayer = CAGradientLayer()
            
            if let pinkColor = UIColor(named: "AuthButtonRed"),
               let defaultColor = UIColor(named: "AuthButtonDark") {
                
                gradientLayer.colors = [pinkColor.cgColor, defaultColor.cgColor]
            } else {
                gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
            }
            
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.frame = self.bounds
            self.layer.insertSublayer(gradientLayer, at: 0)
            
        case .registration:
            self.setTitle("Регистрация", for: .normal)
            self.setTitleColor(.brown, for: .normal)
        }
    }
}
