//  CustomStepper.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit

final class CustomStepper: UIControl {
    
    var currentValue = 1 {
        didSet {
            currentValue = currentValue > 0 ? currentValue : 0
            currentStepValueLabel.text = "\(currentValue)"
        }
    }
    private lazy var decreaseButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlack, for: .normal)
        button.setTitle("-", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    private lazy var currentStepValueLabel: UILabel = {
        var label = UILabel()
        label.textColor = .systemBlack
        label.text = "\(currentValue)"
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: UIFont.Weight.regular)
        
        return label
    }()
    private lazy var increaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.setTitleColor(.systemBlack, for: .normal)
        return button
    }()
    private lazy var horizontalStackView = StackView(style: .horizontal)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
       
        backgroundColor = .systemGray5
        layer.cornerRadius = 20
        addSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(decreaseButton)
        horizontalStackView.addArrangedSubview(currentStepValueLabel)
        horizontalStackView.addArrangedSubview(increaseButton)
        currentStepValueLabel.textAlignment = .center
    }
    
    private func setupContraints() {
      
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
      
        switch sender {
        case decreaseButton:
            currentValue -= 1
        case increaseButton:
            currentValue += 1
        default:
            break
        }
        sendActions(for: .valueChanged)
    }
}
