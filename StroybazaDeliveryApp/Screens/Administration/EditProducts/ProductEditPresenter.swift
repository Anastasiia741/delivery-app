//  ProductPresenter.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 27/12/23.

import Foundation

protocol ProductEditPresenterProtocol: AnyObject {
    func viewDidLoad()
    func categoryCellTapped(_ category: Category)
    func productCellTapped(_ product: Product)
    var newCategories: [Category] { get set }
    var selectedCategory: Category? { get set }
    var selectedProduct: Product? { get set }
    var products: [Product] { get set }
    var banners: [Product] { get set }
}

final class ProductEditPresenter {
    
    weak var view: ProductEditViewProtocol?
//  MARK: - Service
    private let productsDB = DBServiceProducts.shared
//  MARK: - Properties
    public var selectedProduct: Product?
    public var selectedCategory: Category? {
        didSet {
            view?.reloadTable()
        }
    }
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
extension ProductEditPresenter: ProductEditPresenterProtocol {
 
    func viewDidLoad() {
        view?.showLoadingIndicator()
        fetchAllProducts()
    }
    
    func categoryCellTapped(_ category: Category) {
        selectedCategory = category
        fetchProducts(for: category)
    }
    
    func productCellTapped(_ product: Product) {
        view?.showDetailScreen(product)
    }
}

//  MARK: - Business Logic
private extension ProductEditPresenter {
    
    func fetchAllProducts() {
        productsDB.fetchAllProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success((let products, let categories)):
                banners = products.filter { $0.category == CategoryName.discount }
                newCategories = categories
                if let defaultCategory = categories.first(where: { $0.category == CategoryName.armature}) {
                    fetchProducts(for: defaultCategory)
                }
                selectedCategory = newCategories.first
            case .failure(let error):
                print("Ошибка при загрузке баннеров: \(error)")
                view?.hideLoadingIndicator()
            }
        }
    }
    
    func fetchProductsBySelectedCategory(_ category: Category) {
        if let selectedCategory = selectedCategory {
            fetchProducts(for: selectedCategory)
        }
    }
    
    func fetchProducts(for category: Category) {
        view?.showLoadingIndicator()
        productsDB.fetchAllProducts { [weak self] result in
            switch result {
            case .success(let (products, _)):
                let filteredProducts = products.filter { $0.category == category.category}
                self?.products = filteredProducts
                self?.view?.hideLoadingIndicator()
                self?.view?.reloadTable()
                
            case .failure(let error):
                print("Ошибка при получении товаров: \(error)")
                self?.view?.hideLoadingIndicator()
            }
        }
    }
}
