//  Colors.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 20/12/23.

import UIKit

extension UIColor {
    static let systemBlack = UIColor(named: "BlackColor")
    static let priceButton = UIColor(named: "PriceButton")
    static let systemGray = UIColor(named: "SystemGray")
    static let promoButton = UIColor(named: "PromoButton")
    static let buyButton = UIColor(named: "BuyButton")
    static let exitButton = UIColor(named: "ExitButton")
    static let whiteColor = UIColor(named: "WhiteAlpha")
    static let blackAlpha = UIColor(named: "BlackAlpha")
    static let statusColor = UIColor(named: "StatusColor")
    static let authButton = UIColor(named: "AuthButtonRed")
    static let backgroundPromo =  UIColor(named: "GrayAlpha")
}

enum StatusColor {
    static let new = "NewStatusColor"
    static let inProgress = "InProgressStatusColor"
    static let sended = "SendedStatusColor"
    static let delivered = "DeliveredStatusColor"
    static let cancelled = "CancelledStatusColor"
}
