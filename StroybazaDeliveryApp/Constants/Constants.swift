//  Constants.swift
//  StroybazaDeliveryApp
//  Created by Artur Igberdin on 12.09.2023.

import UIKit

enum Images {
    
    enum TabBar {
        static let menu = UIImage(systemName: "house")
        static let cart = UIImage(systemName: "cart.fill")
        static let profile = UIImage(systemName: "person.crop.circle.dashed")
        static let order = UIImage(systemName: "storefront.circle")
        static let product = UIImage(systemName: "tshirt.circle")
        static let createProduct = UIImage(systemName: "plus.circle")
    }
    
    enum Menu {
        static let admin = UIImage(systemName: "person.fill.badge.plus")
    }
    
    enum Picture {
        static let productImage = "photo"
        static let productImageBase = "metal"
    }
}

enum Users {
    static let userId = "WCqAfE0ogLesdYhHKTsbt7j7i443"
}

enum Titles {
    static let menu = "Меню"
    static let cart = "Корзина"
    static let profile = "Профиль"
    static let products = "Десерты"
    static let orderAdmin = "Заказы"
    static let addProduct = "Добавить товар"
    static let detailProduct = "Детали заказа"
}
                        
enum Sections {
    static let cart = 2
    static let productsAdmin = 1
    static let none = 0
}

enum SectionRows {
    static let banner = 1
    static let category = 1
    static let profile = 1
    static let createProduct = 1
    static let none = 0
}

enum CellHeight {
    static let category: CGFloat = 80
    static let adminOrders: CGFloat = 80
    static let adminImage: CGFloat = 300
    static let profileName: CGFloat = 100
    static let profileAddress: CGFloat = 160
    static let profileTitleOrders: CGFloat = 50
    static let profileOrders: CGFloat = 100
    static let profileDefault: CGFloat = 80
    static let product: CGFloat = 160
    
}

enum FieldType {
    case name
    case address
    case number
    case email
    case unknown
}

enum CollorBackground {
    static let priceButton = "PriceButton"
    static let buyButton = "BuyButton"
    static let backgroundPromo = "GrayAlpha"
    static let orderButtonHeader = "normalButtonBackground"
    static let orderButtonHeaderTap = "pressedButtonBackground"
}

enum ButtonsName {
    static let exit = "arrow.right.doc.on.clipboard"
    static let edit = "square.grid.3x1.folder.badge.plus"
    static let save =  "Save"
    
}

enum CategoryName {
    static let armature = "арматура"
    static let discount = "акции"
}

enum TextMessage {
    static let empty = ""
    static let descriptionMain = "Введите описание для главного экрана"
    static let descriptionDetail = "Введите подробное описание"
    static let cardMessade = "Заказ успешно отправлен. Сумма заказа:"
    static let cardEmpty = "Ваша корзина пока пуста"
    static let cardOrder = "Мы уже готовим ваш заказ. Ожидайте 🌺"
    static let authorization = "Авторизация"
    static let registration = "Регистрация"
    static let policy = "https://ilten.github.io/app-policy/"
}

