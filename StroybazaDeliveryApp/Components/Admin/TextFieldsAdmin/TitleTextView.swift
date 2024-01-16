//  TitleTextField.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 23/8/23.

import UIKit

enum TitleTextViewType {
    case descriptionForMain, descriptionForDetail
}

final class TitleTextView: UITextView, UITextViewDelegate {
    private var style: TitleTextViewType

    init(style: TitleTextViewType ) {
        self.style = style
        super.init(frame: .zero, textContainer: nil)
        commonInit(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(_ style: TitleTextViewType) {
        self.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.priceButton?.cgColor
        self.isScrollEnabled = true
        setupTextView()
    }
    
    private func setupTextView() {
        self.textColor = UIColor.systemGray
        self.backgroundColor = .systemGray5
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
}

