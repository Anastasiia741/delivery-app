//  DetailOrderPresenter.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 26/12/23.

import Foundation

protocol DetailOrderPresenterProtocol {
    var selectOrder: Order? {get set}
    func fetchUserProfile()
    func fetchOrderStatus()
    func fetchOrderDetails()
    func buttonStatusTapped(orderID: String, newStatus: String)
    func formatOrderItemsText(for order: Order) -> String
}

final class DetailOrderPresenter {
   
    weak var view: DetailOrderController?
//  MARK: - Properties
    public var user: NewUser?
    public var selectOrder: Order?
    private let profileService = DBServiceProfile.shared
    private let orderService = DBServiceOrders.shared
}

//  MARK: - Bussunes logic
extension DetailOrderPresenter: DetailOrderPresenterProtocol {
    
    func buttonStatusTapped(orderID: String, newStatus: String) {
        if let orderID = selectOrder?.id {
            orderService.updateOrderStatus(orderID: orderID, newStatus: newStatus)
        }
    }
    
    func fetchUserProfile() {
        guard let userID = selectOrder?.userID else { return }
        profileService.getProfile(by: userID) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                self?.view?.showUserInfo(name: user.name, email: user.email, address: user.address, phoneNumber: user.phone)
            case .failure(let error):
                print("Ошибка при получении профиля пользователя: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchOrderDetails() {
        if let order = selectOrder {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy \nВремя - HH:mm"
            let dateString = dateFormatter.string(from: order.date)
            let orderItemsText = formatOrderItemsText(for: order)
            view?.showOrder(date: dateString, order: orderItemsText, promocode: order.promocode,  amount: order.cost)
        }
    }
    
    func formatOrderItemsText(for order: Order) -> String {
        var itemsText = ""
        for position in order.positions {
            let itemText = "\(position.product.name): \(position.count) шт."
            if itemsText.isEmpty {
                itemsText = itemText
            } else {
                itemsText += "\n\(itemText)"
            }
        }
        
        return itemsText
    }
    
    func fetchOrderStatus() {
        if let orderID = selectOrder?.id {
            orderService.fetchOrderStatus(orderID: orderID) { [weak self] (status) in
                if let status = status {
                    self?.view?.showStatusButton(status: status)
                } else {
                    print("Не удалось получить статус заказа.")
                }
            }
        }
    }
}
