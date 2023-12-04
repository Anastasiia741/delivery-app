//  StatusButton.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 15/8/23.

import UIKit

class StatusButton: UIButton {
    private let highlightColor: UIColor
    private let releaseColor: UIColor
    
    init(style: OrderStatus, highlightColor: UIColor, releaseColor: UIColor) {
        self.highlightColor = highlightColor
        self.releaseColor = releaseColor
        super.init(frame: .zero)
        commonInit(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(_ style: OrderStatus) {
        
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = .gray.withAlphaComponent(0.5)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.clipsToBounds = true
        self.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        switch style {
        case .all:
            self.setTitle(OrderStatus.all.rawValue, for: .normal)
        case .new:
            self.setTitle(OrderStatus.new.rawValue, for: .normal)
        case .processing:
            self.setTitle(OrderStatus.processing.rawValue, for: .normal)
        case .shipped:
            self.setTitle(OrderStatus.shipped.rawValue, for: .normal)
        case .delivered:
            self.setTitle(OrderStatus.delivered.rawValue, for: .normal)
        case .cancelled:
            self.setTitle(OrderStatus.cancelled.rawValue, for: .normal)
        }
        tapButtons()
    }
    
    private func tapButtons() {
        addTarget(self, action: #selector(buttonTapped(_:)), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(buttonReleased(_:)), for: .touchUpOutside)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        self.backgroundColor = highlightColor
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        self.backgroundColor = releaseColor
    }
}
