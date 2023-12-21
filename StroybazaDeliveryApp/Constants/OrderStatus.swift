//  OrderStatus.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 14/9/23.

import Foundation

enum OrderStatus: String, CaseIterable {
    case all = "все"
    case new = "новый"
    case processing = "в обработке"
    case shipped = "отправлен"
    case delivered = "доставлен"
    case cancelled = "отменен"
}

