//  Colors.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 21/12/23.

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

extension UIColor {
    static var gradientDarkGrey: UIColor {
        return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
    }
    
    static var gradientLightGrey: UIColor {
        return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
    }
}

enum StatusColor {
    static let new = "NewStatusColor"
    static let inProgress = "InProgressStatusColor"
    static let sended = "SendedStatusColor"
    static let delivered = "DeliveredStatusColor"
    static let cancelled = "CancelledStatusColor"
}
