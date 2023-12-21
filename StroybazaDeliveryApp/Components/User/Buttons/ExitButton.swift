//  ExitButton.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit

final class ExitButtonView: UIView {
    let exitButton = ExitButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(exitButton)
    }
    
    private func setupConstraints() {
        exitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
}

final class ExitButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        self.setTitle("Выйти", for: .normal)
        self.setTitleColor(.systemBackground, for: .normal)
        self.backgroundColor = .exitButton
        self.layer.cornerRadius = 20
    }
}
