//  OrderDetailLabel.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 16/8/23.

import UIKit

enum OrderDetailType {
    case name, email, numberOrder, address, phoneNumber, order, amount, descriptionForMain, descriptionForDetail, productName, productPrice, productCategory, productDescription, productDetail
}

final class OrderDetailLabel: UILabel {
    
    init(style: OrderDetailType) {
        super.init(frame: .zero)
        commonInit(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(_ style: OrderDetailType) {
      
        self.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.numberOfLines = 0

        switch style {
        case .numberOrder:
            self.text = "Номер заказа №23 \nДата заказа 23.10.2023 - 19:58"

        case .address:
            self.text = "Адресс доставки: \n______"

        case .phoneNumber:
            self.text = "Номер телефона: \n+996 ______"

        case .order:
            self.text = "Заказ: \nШоколадный 1 \nМедовый 2 \nЧизкейк 2"
            self.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        case .amount:
            self.text = "Сумма: 2320 сом"
            self.font = UIFont.boldSystemFont(ofSize: 22)

        case .name:
            self.text = "Не указано имя"
        case .email:
            self.text = "Почта: не указана"
        case .descriptionForMain:
            self.text = TextMessage.descriptionMain
            self.textColor = .lightGray
        case .descriptionForDetail:
            self.text = TextMessage.descriptionDetail
            self.textColor = .lightGray
        case .productName:
            self.text = "Название:"
            self.textColor = .lightGray
            self.font = UIFont.boldSystemFont(ofSize: 18)
        case .productPrice:
            self.text = "Цена:"
            self.textColor = .lightGray
            self.font = UIFont.boldSystemFont(ofSize: 18)
        case .productCategory:
            self.text = "Категория:"
            self.textColor = .lightGray
            self.font = UIFont.boldSystemFont(ofSize: 18)
        case .productDescription:
            self.text = "Описание для главной:"
            self.textColor = .lightGray
            self.font = UIFont.boldSystemFont(ofSize: 18)
        case .productDetail:
            self.text = "Подробное описание:"
            self.textColor = .lightGray
            self.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }
}

