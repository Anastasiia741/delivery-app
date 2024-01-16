//  AdminPresenter.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 26/12/23.

import Foundation

protocol AdminPresenterProtocol {
    var orders: [Order] {get set}
    var filteredOrders: [Order] {get set}
    func logout()
    func fetchUserOrders()
    func filterOrdersByStatus(_ status: OrderStatus)
}

final class AdminPresenter {
   
    weak var view: AdminController?
//  MARK: - Properties
    public var filteredOrders: [Order] = [] {
        didSet {
            view?.reloadTable()
        }
    }
    public var orders: [Order] = []{
        didSet {
            view?.reloadTable()
        }
    }
    private let databaseService = DBServiceOrders.shared
    var selectOrder: Order?
    private var selectedStatus: OrderStatus = .all
}

//  MARK: - Navigation
extension AdminPresenter {
   
    func logout() {
        DBServiceAuth.shared.signOut { [weak self] result in
            switch result {
            case .success:
                self?.view?.showMainMenu()
            case .failure(let error):
                print("Ошибка выхода: \(error.localizedDescription)")
            }
        }
    }
}

//  MARK: - Business Logic
extension AdminPresenter: AdminPresenterProtocol {
    
    func filterOrdersByStatus(_ status: OrderStatus) {
        selectedStatus = status
        switch status {
        case .all:
            filteredOrders = orders
        default:
            filteredOrders = orders.filter { $0.status == status.rawValue }
        }
        view?.reloadTable()
    }
    
    func fetchUserOrders() {
        databaseService.fetchUserOrders { [weak self] orders  in
            let sortedOrders = orders.sorted(by: { $0.date > $1.date })
            self?.orders = sortedOrders
            self?.filterOrdersByStatus(.all)
            self?.view?.reloadTable()
        }
    }
}
