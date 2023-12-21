//  StatusButton.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 15/8/23.

import UIKit

class StatusButton: UIButton {
    private let highlightColor: UIColor
    private let releaseColor: UIColor
    private var highlightAnimator: UIViewPropertyAnimator?

    
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
        self.layer.borderColor = UIColor.systemGray2.cgColor
        self.setTitleColor(.systemBlack, for: .normal)
        self.backgroundColor = .systemGray2
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
        addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc private func buttonTapped() {
           highlightAnimator?.stopAnimation(true)
           highlightAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
               self.backgroundColor = self.highlightColor
           }
           highlightAnimator?.startAnimation()
       }

       @objc private func buttonReleased() {
           highlightAnimator?.stopAnimation(true)
           highlightAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
               self.backgroundColor = self.releaseColor
           }
           highlightAnimator?.startAnimation()
       }
}
