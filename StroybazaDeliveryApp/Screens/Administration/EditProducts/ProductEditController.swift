//  ProductController.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 27/12/23.

import UIKit

protocol ProductEditViewProtocol: AnyObject {
    func reloadTable()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showDetailScreen(_ product: Product)
}

final class ProductEditController: UIViewController {
    
    public var presenter: ProductEditPresenterProtocol?
    private let editModuleConfigurator = EditModuleConfigurator()
//  MARK: - UI
    private let activityIndicator = ActivityIndicator(style: .medium)
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
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
}

//  MARK: - Life Cycle
extension ProductEditController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
    }
}

//  MARK: - Presentation Logic
extension ProductEditController: ProductEditViewProtocol {
 
    func reloadTable() {
        tableView.reloadData()
    }
    
    func showDetailScreen(_ product: Product) {
        let viewController = editModuleConfigurator.configure()
        viewController.presenter?.selectedProduct = product
        navigationController?.navigationBar.tintColor = .buyButton
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func categoryCellTapped(_ category: Category) {
        presenter?.categoryCellTapped(category)
    }
}

//  MARK: - Activity Indicator
 extension ProductEditController {
    
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

//  MARK: - Layout
private extension ProductEditController {
    
    func setupViews() {
        view.addSubview(tableView)
    }
    
    func setupStyles() {
        view.backgroundColor = .systemBackground
        self.navigationItem.title = Titles.products
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//  MARK: - TableViewDataSource, TableViewDelegate
extension ProductEditController: UITableViewDataSource, UITableViewDelegate {
    
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
            return presenter?.products.count ?? 0
        default:
            return Sections.none
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = MenuSection.init(rawValue: indexPath.section)
        
        switch section {
        case .banner:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannerCell.reuseId, for: indexPath) as! BannerCell
            cell.update(products: presenter?.banners ?? [])
            cell.onBannerTapped = { banner in
                self.showDetailScreen(banner)
            }
            
            return cell
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseID, for: indexPath) as! CategoryCell
            cell.update(categories: presenter?.newCategories ?? [])
            cell.onCategoryTapped = { [weak self] category in
                self?.categoryCellTapped(category)
            }
            
            return cell
        case .products:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseId, for: indexPath) as! ProductCell
            guard let product = presenter?.products[indexPath.row] else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            if let selectedCategory = presenter?.selectedCategory, product.category == selectedCategory.category {
                cell.isPriceButtonVisible = false
                cell.update(withProduct: product)

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
            if let selectedProduct = presenter?.products[indexPath.row] {
                presenter?.productCellTapped(selectedProduct)
            }
        case .some(.banner):
            break
        case .none:
            break
        }
    }
}
