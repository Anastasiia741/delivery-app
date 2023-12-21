//  DetailButton.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 16/8/23.

import UIKit

enum DetailButtonType {
    case detail, accept}

final class DetailButton: UIButton {
     let highlightColor: UIColor
     let releaseColor: UIColor
    
    init(style: DetailButtonType, highlightColor: UIColor, releaseColor: UIColor) {
        self.highlightColor = highlightColor
        self.releaseColor = releaseColor
        super.init(frame: .zero)
        commonInit(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(_ style: DetailButtonType){
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.systemGray2.cgColor
        self.setTitleColor(.systemBlack, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.clipsToBounds = true
        self.setTitle("подробнее", for: .normal)
        
        switch style {
        case .accept:
            self.setTitle("принять", for: .normal)
            self.backgroundColor = .systemGreen
        case .detail:
            self.setTitle("подробнее", for: .normal)
            self.backgroundColor = .systemBlue
        }
        
        tapButtons()
    }
    
    func tapButtons() {
        addTarget(self, action: #selector(buttonReleased(_:)), for: .touchDown)
        addTarget(self, action: #selector(buttonTapped(_:)), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        self.backgroundColor = highlightColor
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        self.backgroundColor = releaseColor
    }
}

