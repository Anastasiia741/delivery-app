//  EditProductScreenVC.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 22/8/23.

import UIKit
import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProductScreenVC: UIViewController {
    
//  MARK: - Service
    private let productsDB = DBServiceProducts.shared
//  MARK: - Properties
    private var selectedProduct: Product?
    private var selectedCategory: Category? {
        didSet {
            tableView.reloadData()
        }
    }
    private var newCategories: [Category] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var products: [Product]  = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var banners: [Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }
//  MARK: - UI
    private let activityIndicator = ActivityIndicator(style: .medium)
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseID)
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseId)
        tableView.register(BannerCell.self, forCellReuseIdentifier: BannerCell.reuseId)
        return tableView
    }()
    private var isUpdatingTable = false
    
//  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
        setupConstraints()
        fetchAllProducts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchAllProducts()
    }
}

//  MARK: - Activity Indicator
private extension ProductScreenVC {
    
    func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.center = self.view.center
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}

//  MARK: - Business Logic
private extension ProductScreenVC {
    
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
                self.isUpdatingTable = false
                self.hideLoadingIndicator()
            }
        }
    }
    
    func fetchProductsBySelectedCategory(_ category: Category) {
        if let selectedCategory = selectedCategory {
            fetchProducts(for: selectedCategory)
        }
    }
    
    func fetchProducts(for category: Category) {
        isUpdatingTable = true
        showLoadingIndicator()
        productsDB.fetchAllProducts { [weak self] result in
            switch result {
            case .success(let (products, _)):
                let filteredProducts = products.filter { $0.category == category.category}
                self?.products = filteredProducts
                self?.isUpdatingTable = false
                self?.hideLoadingIndicator()
                self?.tableView.reloadData()
                
            case .failure(let error):
                print("Ошибка при получении товаров: \(error)")
                self?.isUpdatingTable = false
                self?.hideLoadingIndicator()
            }
        }
    }
}

//  MARK: - Navigation
extension ProductScreenVC {
    func showDetailScreen(_ product: Product) {
        let viewController = EditDetailProductScreenVC()
        viewController.selectedProduct = product
        navigationController?.navigationBar.tintColor = UIColor(named: CollorBackground.buyButton)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//  MARK: - Actions
extension ProductScreenVC {
    private func categoryCellTapped(_ category: Category) {
        selectedCategory = category
        fetchProducts(for: category)
    }
}

//  MARK: - Layout
private extension ProductScreenVC {
    
    func setupViews() {
        view.addSubview(tableView)
    }
    
    func setupStyles() {
        view.backgroundColor = .white
        self.navigationItem.title = Titles.products
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//  MARK: - TableViewDataSource, TableViewDelegate
extension ProductScreenVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = MenuSection.init(rawValue: indexPath.section)
        switch section {
        case .category:
            return CellHeight.category
        default:
            return UITableView.automaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MenuSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = MenuSection.init(rawValue: section)
        switch section {
        case .banner:
            return Sections.productsAdmin
        case .category:
            return SectionRows.category
        case .products:
            return products.count
        default:
            return Sections.none
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = MenuSection.init(rawValue: indexPath.section)
        switch section {
        case .banner:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannerCell.reuseId, for: indexPath) as! BannerCell
            cell.update(products: banners)
            cell.onBannerTapped = { banner in
                self.showDetailScreen(banner)
            }
            
            return cell
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseID, for: indexPath) as! CategoryCell
            cell.update(categories: newCategories)
            cell.onCategoryTapped = { [weak self] category in
                self?.categoryCellTapped(category)
            }
            
            return cell
        case .products:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseId, for: indexPath) as! ProductCell
            let product = products[indexPath.row]
            cell.selectionStyle = .none
            
            if let selectedCategory = selectedCategory, product.category == selectedCategory.category {
                cell.isPriceButtonVisible = false
                cell.update(withProduct: product)
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = MenuSection(rawValue: indexPath.section)
        switch section {
        case .banner:
            selectedProduct = banners[indexPath.row]
        case .products:
            selectedProduct = products[indexPath.row]
        default:
            break
        }
        if let selectedProduct = selectedProduct {
            showDetailScreen(selectedProduct)
        }
    }
}
