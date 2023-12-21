//  MenuScreenVC.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

//  MARK: - Sections name
enum MenuSection: Int, CaseIterable {
    case  banner, category, products
}

final class MenuScreenVC: UIViewController {
    
//  MARK: - Service
    private let orderService = OrderService()
    private let productsDB = DBServiceProducts.shared
//  MARK: - Properties
    private let skeletonView = SkeletonView()
    private var selectedProduct: Product?
    private var selectedCategory: Category?
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
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(BannerCell.self, forCellReuseIdentifier: BannerCell.reuseId)
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseID)
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseId)
        return tableView
    }()
    private let isLoaded = true
    
//  MARK: - Life Cucle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupViews()
        setupConstraints()
    
        showSkeletonLoading()
        fetchAllProducts()
    }
}

//  MARK: - Skeleton View
private extension MenuScreenVC {
    func showSkeletonLoading() {
        view.addSubview(skeletonView)
        skeletonView.backgroundColor = .systemBackground
        
        skeletonView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func hideSkeletonLoading() {
        skeletonView.removeFromSuperview()
        tableView.reloadData()
    }
}

//  MARK: - Business Logic
extension MenuScreenVC: ProductCellDelegate {
    private func fetchAllProducts() {
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
                    self.hideSkeletonLoading()
                case .failure(let error):
                    print("Ошибка при загрузке баннеров: \(error)")
                }
            }
        }
    }
    
    private func fetchProductsBySelectedCategory() {
        if let selectedCategory = selectedCategory {
            fetchProducts(for: selectedCategory)
        }
    }
    
    private func fetchProducts(for category: Category) {
        productsDB.fetchAllProducts { [weak self] result in
            switch result {
            case .success(let (products, _)):
                let filteredProducts = products.filter { $0.category == category.category}
                self?.products = filteredProducts
                self?.tableView.reloadData()
            case .failure(let error):
                print("Ошибка при получении товаров: \(error)")
            }
        }
    }
}

//  MARK: - Navigation
private extension MenuScreenVC {
    func showDetailScreen(_ product: Product) {
        let viewController = ProductDetailScreenVC()
        viewController.selectedProduct = product
        present(viewController, animated: true)
    }
}

//  MARK: - Actions
extension MenuScreenVC {
    private func categoryCellTapped(_ category: Category) {
        selectedCategory = category
        fetchProducts(for: category)
    }
    
    func priceButtonTapped(for product: Product) {
        _ = orderService.addProduct(product)
    }
}

//  MARK: - Layout
private extension MenuScreenVC {
    
    func setupStyles() {
        view.backgroundColor = .systemBackground
        self.navigationItem.title = Titles.menu
    }
    
    func setupViews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//  MARK: - TableViewDataSource, TableViewDelegate
extension MenuScreenVC: UITableViewDataSource, UITableViewDelegate {
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
            return SectionRows.banner
        case .category:
            return SectionRows.category
        case .products:
            return products.count
        default:
            return SectionRows.none
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = MenuSection.init(rawValue: indexPath.section)
        switch section {
        case .banner:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannerCell.reuseId, for: indexPath) as! BannerCell
            cell.update(products: banners)
            cell.selectionStyle = .none
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
                cell.update(withProduct: product)
                cell.delegate = self
            } else {
                cell.isHidden = true
            }
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = MenuSection(rawValue: indexPath.section)
        switch section {
        case .category:
            break
        case .products:
            let selectedProduct = products[indexPath.row]
            showDetailScreen(selectedProduct)
        case .some(.banner):
            break
        case .none:
            break
        }
    }
}
