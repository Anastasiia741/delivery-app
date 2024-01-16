//  MenuPresenter.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import Foundation

protocol MenuPresenterProtocol: AnyObject {
//  MARK: - View Events
    func viewDidLoad()
//  MARK: -  User Events
    func categoryCellTapped(_ category: Category)
    func priceButtonCellTapped(_ product: Product)
    func bannerCellTapped(_ banner: Product)
    func productCellTapped(_ product: Product)
//  MARK: - Models
    var newCategories: [Category] { get set }
    var products: [Product] { get set }
    var banners: [Product] { get set }
    var selectedProduct: Product? { get set }
    var selectedCategory: Category? { get set }
//  MARK: - Businedd Logic
    func fetchAllProducts()
    func fetchProductsBySelectedCategory()
    func fetchProducts(for category: Category)
}

final class MenuPresenter {
    
    weak var view: MenuViewProtocol?
//  MARK: - Database
    private let orderService = OrderService()
    private let productsDB = DBServiceProducts.shared
//  MARK: - Models
    public var selectedProduct: Product?
    public var selectedCategory: Category?
    public var newCategories: [Category] = [] {
        didSet {
            view?.reloadTable()
        }
    }
    public var products: [Product]  = [] {
        didSet {
            view?.reloadTable()
        }
    }
    public var banners: [Product] = [] {
        didSet {
            view?.reloadTable()
        }
    }
}

//  MARK: - View Events
extension MenuPresenter: MenuPresenterProtocol {

    func viewDidLoad() {
        view?.showSkeletonLoading()
        fetchAllProducts()
    }
    
    func categoryCellTapped(_ category: Category) {
        selectedCategory = category
        fetchProducts(for: category)
    }
    
    func priceButtonCellTapped(_ product: Product) {
        _ = orderService.addProduct(product)
    }
    
    func bannerCellTapped(_ banner: Product) {
        view?.showDetailScreen(banner)
    }
    
    func productCellTapped(_ product: Product) {
        view?.showDetailScreen(product)
    }
}

//MARK: - Business Logic
extension MenuPresenter {
    
    func fetchAllProducts() {
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            self.productsDB.fetchAllProducts { [weak self] result in
                guard let self = self else { return }
                switch result {
                case.success((let products, let categories)):
                    banners = products.filter { $0.category == CategoryName.discount }
                    newCategories = categories
                    if let defaultCategory = categories.first(where: { $0.category == CategoryName.armature}) {
                        fetchProducts(for: defaultCategory)
                    }
                    selectedCategory = newCategories.first
                    view?.hideSkeletonLoading()
                    
                case .failure(let error):
                    print("Ошибка при загрузке баннеров: \(error)")
                }
            }
        }
    }
    
    func fetchProductsBySelectedCategory() {
        if let selectedCategory = selectedCategory {
            fetchProducts(for: selectedCategory)
        }
    }
    
    func fetchProducts(for category: Category) {
        
        productsDB.fetchAllProducts { [weak self] result in
            switch result {
            case .success(let (products, _)):
                let filteredProducts = products.filter { $0.category == category.category}
                self?.products = filteredProducts
                
                self?.view?.reloadTable()
                
            case .failure(let error):
                print("Ошибка при получении товаров: \(error)")
            }
        }
    }
}
