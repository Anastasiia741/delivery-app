//  StackView.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 25/8/23.

import UIKit

enum StackViewType {
    case vertical, horizontal, verticalForAuth, verticalForProduct, verticalForPromo
}

final class StackView: UIStackView {
    
    init(style: StackViewType ) {
        super.init(frame: .zero)
        commonInit(style)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(_ style: StackViewType) {
        self.spacing = 15
        self.alignment = .leading
        
        switch style{
        case .vertical:
            self.axis = .vertical
            self.spacing = 10
            self.distribution = .fillEqually
            self.alignment = .fill
        case .horizontal:
            self.axis = .horizontal
            self.spacing = 10
            self.distribution = .fillEqually
            self.alignment = .fill


        case .verticalForAuth:
            self.axis = .vertical
            self.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            self.isLayoutMarginsRelativeArrangement = true
            self.distribution = .fill
            self.alignment = .fill
        case .verticalForProduct:
            self.axis = .vertical
            self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 12, trailing: -10)
            self.isLayoutMarginsRelativeArrangement = true
        case .verticalForPromo:
            self.axis = .vertical
            self.spacing = 10
            self.alignment = .trailing
        }
    }
}

