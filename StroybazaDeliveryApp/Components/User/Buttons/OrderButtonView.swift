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
                                  highlightColor: .buyButton?.withAlphaComponent(0.7) ?? UIColor.red,
                                  releaseColor: .buyButton?.withAlphaComponent(0.9) ?? UIColor.red)
    var saveButton = OrderButton(style: OrderButtonType.save,
                                 highlightColor: .buyButton?.withAlphaComponent(0.7) ?? UIColor.red,
                                 releaseColor: .buyButton?.withAlphaComponent(0.5) ?? UIColor.red)
    var removeButton = OrderButton(style: OrderButtonType.remove,
                                   highlightColor: .buyButton?.withAlphaComponent(0.7) ?? UIColor.red,
                                   releaseColor: .buyButton?.withAlphaComponent(0.5) ?? UIColor.red)

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
        self.layer.borderColor = UIColor.systemGray?.cgColor
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
        self.setTitleColor(.systemBlack, for: .normal)
        self.backgroundColor = .buyButton
        self.layer.cornerRadius = 20
        self.tintColor = .systemBackground
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
      
        switch style {
        case .order:
            self.setTitle("Заказать", for: .normal)
        case .save:
            self.setTitle("Сохранить", for: .normal)
            self.backgroundColor = .buyButton?.withAlphaComponent(0.6)
                self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.buyButton?.cgColor
        case .remove:
            self.setTitle("Удалить", for: .normal)
            self.backgroundColor = .systemBlue.withAlphaComponent(0.4)
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.7).cgColor
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
