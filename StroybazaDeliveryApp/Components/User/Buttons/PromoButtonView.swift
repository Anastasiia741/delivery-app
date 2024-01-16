//  PromoButtonView.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit

final class PromoButtonView: UIView {
    
    var promoButton = PromoButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(promoButton)
    }
   
    private func setupConstraints() {
        promoButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
    }
}

final class PromoButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
       
        self.setTitle("Ввести промокод", for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = .promoButton
        self.layer.cornerRadius = 20
        self.tintColor = .systemBackground
        self.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
    }
}

