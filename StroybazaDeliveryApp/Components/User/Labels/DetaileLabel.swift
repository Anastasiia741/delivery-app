//  DetaileLabelType.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit

enum DetaileLabelType {
    case detail, product
}

final class DetaileLabel: UILabel {
    
    init(style: DetaileLabelType ) {
        super.init(frame: .zero)
        commonInit(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(_ style: DetaileLabelType) {
        
        switch style{
        case .detail:
            self.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            self.numberOfLines = 0
            self.tintColor = .systemGray2
        case .product:
            self.font = UIFont.italicSystemFont(ofSize: 16)
            self.numberOfLines = 0
            self.tintColor = .systemGray2
        }
    }
}
