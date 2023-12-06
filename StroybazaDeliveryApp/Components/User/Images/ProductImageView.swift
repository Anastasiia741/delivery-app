//  ProductImageView.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit


enum ProductImageType {
    case menu, menuSkeleton, cart, detail, editProduct
}

final class ProductImageView: UIImageView {
    private var images: [UIImage] = []
    
    init(style: ProductImageType) {
        super.init(frame: .zero)
        commonInit(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(_ style: ProductImageType) {
        
        self.contentMode = .scaleAspectFill
        let width = UIScreen.main.bounds.width
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor(named: "PriceButton")?.cgColor
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .menu:
            self.heightAnchor.constraint(equalToConstant: 0.35 * width).isActive = true
            self.widthAnchor.constraint(equalToConstant: 0.35 * width).isActive = true
            self.contentMode = .scaleAspectFill
        case .detail:
            self.heightAnchor.constraint(equalToConstant: 0.9 * width).isActive = true
            self.widthAnchor.constraint(equalToConstant: 0.9 * width).isActive = true
        case .cart:
            self.heightAnchor.constraint(equalToConstant: 0.25 * width).isActive = true
            self.widthAnchor.constraint(equalToConstant: 0.25 * width).isActive = true
            self.contentMode = .scaleAspectFill
        case .editProduct:
            self.heightAnchor.constraint(equalToConstant: 0.7 * width).isActive = true
            self.widthAnchor.constraint(equalToConstant: 0.7 * width).isActive = true
            self.image = UIImage(named: "photo")
            self.isUserInteractionEnabled = true
            self.contentMode = .scaleAspectFill
        case .menuSkeleton:
            self.layer.cornerRadius = 8
            self.layer.borderWidth = 0
            self.backgroundColor = .lightGray
            self.image = UIImage()
        }
    }
}
