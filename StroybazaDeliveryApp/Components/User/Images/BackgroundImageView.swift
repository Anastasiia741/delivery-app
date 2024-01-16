//  backgroundImageView.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 3/8/23.

import UIKit

final class BackgroundImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.image = UIImage(named: "logo")
        self.contentMode = .scaleAspectFit
    }
}
