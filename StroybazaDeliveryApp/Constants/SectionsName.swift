//  Pages.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 21/12/23.

import Foundation

//  MARK: - Sections name
enum MenuSection: Int, CaseIterable {
    case  banner, category, products
}

enum CartSection: Int, CaseIterable {
    case order, promoProducts
}

enum AuthError: Error {
    case noCurrentUser
}

enum ProfileSection: Int, CaseIterable {
    case name, address, titleOrders, orders
}

enum CreateProductSection: Int, CaseIterable {
    case  image, name, detail
}
