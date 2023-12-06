//  ProfileImageView.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit

final class ProfileImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        self.image = UIImage(named: "profile")
        self.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = true
        
        self.heightAnchor.constraint(equalToConstant: 85).isActive = true
        self.widthAnchor.constraint(equalToConstant: 85).isActive = true
        self.layer.cornerRadius = 40
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 2
    }
}

