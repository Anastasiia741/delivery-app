//  PriceButtonType.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit

enum PriceButtonType {
    case colorBackground, colorSkeleton, noneBackground, cartButton, editButton
}

final class PriceButton: UIButton {
    
    init(style: PriceButtonType) {
        super.init(frame: .zero)
        commonInit(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(_ style: PriceButtonType) {
      
        self.setTitle("от 850 сом", for: .normal)
        self.layer.cornerRadius = 20
        self.setTitleColor(.systemBrown, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        switch style {
        case .colorBackground:
            self.backgroundColor = .priceButton?.withAlphaComponent(0.4)
        case .noneBackground:
            self.backgroundColor = .none
        case .cartButton:
            self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        case .editButton:
            self.setTitle("изменить", for: .normal)
            self.setTitleColor(.systemGray, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            self.isUserInteractionEnabled = true
        case .colorSkeleton:
            self.layer.cornerRadius = 8
            self.setTitle("", for: .normal)
            self.backgroundColor = .systemGray
        }
    }
}
