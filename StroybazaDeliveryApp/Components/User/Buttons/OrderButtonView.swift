//  OrderButtonView.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit

enum OrderButtonType {
    case order, save, remove
}

final class OrderButtonView: UIView {
    var orderButton = OrderButton(style: OrderButtonType.order,
                                  highlightColor: UIColor(named: "BuyButton")?.withAlphaComponent(0.7) ?? UIColor.red,
                                  releaseColor: UIColor(named: "BuyButton")?.withAlphaComponent(0.5) ?? UIColor.red)
    var saveButton = OrderButton(style: OrderButtonType.save,
                                 highlightColor: UIColor(named: "BuyButton")?.withAlphaComponent(0.7) ?? UIColor.red,
                                 releaseColor: UIColor(named: "BuyButton")?.withAlphaComponent(0.5) ?? UIColor.red)
    var removeButton = OrderButton(style: OrderButtonType.remove,
                                   highlightColor: UIColor(named: "BuyButton")?.withAlphaComponent(0.7) ?? UIColor.red,
                                   releaseColor: UIColor(named: "BuyButton")?.withAlphaComponent(0.5) ?? UIColor.red)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyles()
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyles() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
    }
    
    private func setupViews() {
        self.addSubview(orderButton)
        self.addSubview(saveButton)
    }
    
    private func setupConstraints() {
     
        orderButton.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(24)
        }
    }
}

final class OrderButton: UIButton {
  
    private let highlightColor: UIColor
    private let releaseColor: UIColor
    
    
    init(style: OrderButtonType, highlightColor: UIColor, releaseColor: UIColor) {
        self.highlightColor = highlightColor
        self.releaseColor = releaseColor
        super.init(frame: .zero)
        commonInit(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(_ style: OrderButtonType) {

        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = UIColor(named: "BuyButton")
        self.layer.cornerRadius = 20
        self.tintColor = .white
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
      
        switch style {
        case .order:
            self.setTitle("Заказать", for: .normal)
        case .save:
            self.setTitle("Сохранить", for: .normal)
                self.backgroundColor = UIColor(named: "BuyButton")?.withAlphaComponent(0.6)
                self.layer.borderWidth = 2
                self.layer.borderColor = UIColor(named: "BuyButton")?.cgColor
        case .remove:
            self.setTitle("Удалить", for: .normal)
            self.backgroundColor = .blue.withAlphaComponent(0.4)
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.blue.withAlphaComponent(0.7).cgColor
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
