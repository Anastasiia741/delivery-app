//  PriceLabelType.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit

enum PriceLabelType {
    case detail, product, price
}

final class PriceLabel: UILabel {
    
    init(style: PriceLabelType ) {
        super.init(frame: .zero)
        commonInit(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(_ style: PriceLabelType) {
        
        switch style{
        case .detail:
            self.font = UIFont.systemFont(ofSize: 20)
            self.tintColor = .brown
        case .product:
            self.font = UIFont.systemFont(ofSize: 15)
        case .price:
            self.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            self.tintColor = .red
        }
    }
}

