//  ActivityIndicator.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 7/9/23.

import UIKit

final class ActivityIndicator: UIActivityIndicatorView {
    
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        color = .systemGray2
        hidesWhenStopped = true
    }
}


