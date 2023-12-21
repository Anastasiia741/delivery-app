//  MainTitleType.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit

enum MainTitleType {
    case detail, product, productSkeleton, promo, menuTitle, cartTitle, cartAddTitle, emailTitle, email, contact, history, auth, orderHistory, orderAmount, orderStatus, titleDetail, disclaimer, deleteAccount
}

final class MainTitleLabel: UILabel {
    
    init(style: MainTitleType) {
        super.init(frame: .zero)
        commonInit(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(_ style: MainTitleType) {
        
        switch style {
        case .detail:
            self.text = "Арматура"
            self.font = UIFont.boldSystemFont(ofSize: 24)
            self.numberOfLines = 0
        case .product:
            self.text = "Арматура"
            self.font = UIFont.boldSystemFont(ofSize: 18)
            self.numberOfLines = 0
        case .promo:
            self.text = "Арматура"
            self.font = UIFont.boldSystemFont(ofSize: 14)
            self.numberOfLines = 3
        case .menuTitle:
            self.text = "Выгодные предложения"
            self.font = UIFont.boldSystemFont(ofSize: 20)
            self.textAlignment = .left
            self.numberOfLines = 0
        case .cartTitle:
            self.text = "2 товара на 1 300 сом"
            self.font = UIFont.boldSystemFont(ofSize: 18)
            self.numberOfLines = 2
            self.textAlignment = .left
        case .emailTitle:
            self.text = "Ваш email:"
            self.font = UIFont.boldSystemFont(ofSize: 18)
        case .email:
            self.text = "email@gmail.com:"
            self.font = .systemFont(ofSize: 18)
        case .contact:
            self.text = "Адрес доставки:"
            self.font = UIFont.boldSystemFont(ofSize: 18)
        case .cartAddTitle:
            self.text = "Добавить к заказу?"
            self.font = .systemFont(ofSize: 18, weight: .medium)
            self.textAlignment = .left
        case .auth:
            self.font = UIFont.boldSystemFont(ofSize: 24)
            self.textAlignment = .center
            self.textColor = .black
            self.backgroundColor = UIColor(named: "BlackAlpha")
            self.layer.cornerRadius = 20
            self.clipsToBounds = true
        case .history:
            self.text = "Ваши заказы"
            self.font = UIFont.boldSystemFont(ofSize: 22)
        case .orderHistory:
            self.text = "Дата заказа"
            self.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        case .orderAmount:
            self.text = "1220 com"
            self.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        case .orderStatus:
            self.text = OrderStatus.new.rawValue
            self.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            self.textColor = UIColor(named: "StatusColor")
        case .titleDetail:
            self.text = "Кофе + круассан"
            self.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            self.numberOfLines = 3
        case .disclaimer:
            self.text = "Политика Конфиденциальности"
            self.textColor = .systemBlack
            self.font = UIFont.systemFont(ofSize: 14, weight: .light)
            self.textAlignment = .center
            self.numberOfLines = 3
            self.isUserInteractionEnabled = true
            
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            let underlineAttributedString = NSAttributedString(string: self.text ?? "", attributes: underlineAttribute)
            self.attributedText = underlineAttributedString
        case .productSkeleton:
            self.text = ""
            self.backgroundColor = .lightGray
        case .deleteAccount:
            self.text = "Удалить аккаунт"
            self.textColor = .gray
            self.textAlignment = .center
            self.font = UIFont.systemFont(ofSize: 14, weight: .light)
            self.isUserInteractionEnabled = true

            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            let underlineAttributedString = NSAttributedString(string: self.text ?? "", attributes: underlineAttribute)
            self.attributedText = underlineAttributedString
        }
    }
}

