//  DetailButton.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 16/8/23.

import UIKit

enum DetailButtonType {
    case edit, accept, detail, create
}

final class DetailButton: UIButton {
    private let highlightColor: UIColor
    private let releaseColor: UIColor
    
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
        self.layer.borderColor = UIColor.gray.cgColor
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = .gray.withAlphaComponent(0.5)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.clipsToBounds = true
        self.setTitle("подробнее", for: .normal)
        self.backgroundColor = .blue.withAlphaComponent(0.5)
        
        switch style {
            
        case .edit:
            self.setTitle("изменить", for: .normal)
            self.backgroundColor = .blue
        case .accept:
            self.setTitle("принять", for: .normal)
            self.backgroundColor = .green
        case .detail:
            self.setTitle("подробнее", for: .normal)
        case .create:
            self.setTitle("добавить", for: .normal)
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            self.backgroundColor = .none
            self.widthAnchor.constraint(equalToConstant: 74).isActive = true
            self.heightAnchor.constraint(equalToConstant: 34).isActive = true
        }
        
        tapButtons()
    }
    
    func tapButtons() {
        addTarget(self, action: #selector(buttonTapped(_:)), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased(_:)), for: .touchUpInside)
        addTarget(self,action: #selector(buttonTapped(_:)), for: .touchUpOutside)
    }
    
    
    @objc private func buttonTapped(_ sender: UIButton) {
        self.backgroundColor = highlightColor
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        self.backgroundColor = releaseColor
    }
}
