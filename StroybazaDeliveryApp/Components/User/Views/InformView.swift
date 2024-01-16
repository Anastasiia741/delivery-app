//  InformView.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit

final class InformView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.backgroundColor = .darkGray
        self.layer.cornerRadius = 6
        self.alpha = 0.0
        
        let infoLabel: UILabel = {
            let label = UILabel()
            label.text = "Заказ оформлен! \nЖдите звонка"
            label.numberOfLines = 3
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textColor = .systemOrange
            return label
        }()
        
        self.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(60)
        }
    }
    
}
