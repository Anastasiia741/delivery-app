//  CartPresenter.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 19/12/23.

import UIKit

protocol CartPresenterProtocol: AnyObject {
    var orderProducts: [Product] {  get set  }
    var products: [Product] { get set }
    var orderService: OrderService { get }

    func viewDidLoad()
    func fetchOrder()
    func orderButtonTapped(with promoCode: String?)
    func addPromoProductToOrder(for product: Product)
}

final class CartPresenter {
//  MARK: - Protocol
    weak var view: CartViewProtocol?
//  MARK: - Database
    private let productsDB = DBServiceProducts.shared
    private let productsRepository = ProductsRepository()
    private let bannerAPI = BannerAPI()
    public var products: [Product]  = [] {
        didSet {
            view?.reloadTable()
        }
    }
    public var orderProducts: [Product] = [] {
        didSet {
            view?.reloadTable()
        }
    }
    public var orderService: OrderService {
    return OrderService()
    }
    public var onTapped: ((Product)->())?
}

//  MARK: - Event Handler
extension CartPresenter {
    func viewDidLoad() {
        fetchPromoProducts()
    }
}

//  MARK: - Business Logic
extension CartPresenter: CartPresenterProtocol {
   
    func fetchPromoProducts() {
        productsDB.fetchAllProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let products, _)):
                let bannerProducts = products.filter { $0.category == CategoryName.discount }
                self.products = bannerProducts
                view?.reloadTable()
            case .failure(let error):
                print("Ошибка при загрузке баннеров: \(error)")
            }
        }
    }
    
    func fetchOrder() {
        self.orderProducts = orderService.retreiveProducts()
        let (count, price) = orderService.calculatePrice()
        if count == 0 {
            view?.showCountLable(message: TextMessage.cardEmpty)
        } else {
            view?.showCountLable(message: "\(price) товара на \(count) сом")
        }
        productsRepository.save(orderProducts)
        view?.reloadTable()
    }
    
    func addPromoProductToOrder(for product: Product) {
        let _ = orderService.addProduct(product)
        fetchOrder()
    }
}

//  MARK: - Order Button
extension CartPresenter {
    func orderButtonTapped(with promoCode: String?) {
        if orderProducts.isEmpty {
            view?.showMenuScreen()
        } else {
            if let currentUser = DBServiceAuth.shared.currentUser {
                var order = Order(id: UUID().uuidString, userID: currentUser.uid, positions: [], date: Date(), status: OrderStatus.new.rawValue, promocode: promoCode ?? "")
                order.positions = orderProducts.map { position in
                    return ProductsPosition(id: UUID().uuidString, product: position, count: position.quantity)
                }
                if order.positions.isEmpty {
                    print("Заказ пуст!")
                } else {
                    DBServiceOrders.shared.saveOrder(order: order, promocode: order.promocode) { [weak self] result in
                        switch result {
                        case .success(let order):
                            print("\(TextMessage.cardMessade) \(order.cost)")
                            self?.orderProducts.removeAll()
                            self?.view?.reloadTable()
                            self?.productsRepository.save(self?.orderProducts ?? [Product]())
                            self?.view?.showCountLable(message: TextMessage.cardOrder)
                            self?.view?.showInformView()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                view?.showAuthScreen()
            }
        }
    }
}
