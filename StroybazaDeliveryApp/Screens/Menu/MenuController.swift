//  MenuScreenVC.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

////Presenter -> Business Logic -> Interactor
//protocol MenuScreenInteractor {
//
//}

//VC -> View Event -> Presenter
//protocol MenuScreenPresenterProtocol (MVP)
//protocol MenuViewEventProtocol (VIP)
//protocol MenuScreenPresenterInput (VIPER)


//-> Presenter Responsibilities:
//Event Handler
//Business Logic -> Services,

//-> Controller Responsibilities:
//Configure UI
//Layout
//Update View

//Interactor -> Update View -> View
protocol MenuViewProtocol: AnyObject {
    
//  Presentation
    func reloadTable()
    func showSkeletonLoading()
    func hideSkeletonLoading()
//  Navigation
    func showDetailScreen(_ product: Product)
}

final class MenuController: UIViewController {
    
    public var presenter: MenuPresenterProtocol?
    public let productModuleConfigurator = ProductModuleConfigurator()
//  MARK: - UI
    private let skeletonView = SkeletonView()
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
}

//  MARK: - Presentation Logic
extension MenuController: MenuViewProtocol {
    func reloadTable() {
        tableView.reloadData()
    }
    
    func showSkeletonLoading() {
        view.addSubview(skeletonView)
        
        skeletonView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func hideSkeletonLoading() {
        skeletonView.removeFromSuperview()
        tableView.reloadData()
    }
}

// MARK: - Navigation Logic
extension MenuController {
    func showDetailScreen(_ product: Product) {
        let viewController = productModuleConfigurator.configure()
        viewController.presenter?.selectedProduct = product
        present(viewController, animated: true)
    }
}

//  MARK: - Life Cycle
extension MenuController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupViews()
        setupConstraints()
        
        presenter?.viewDidLoad()
    }
}

//  MARK: - Event Handler
private extension MenuController {
    func categoryCellTapped(_ category: Category) {
        presenter?.categoryCellTapped(category)
    }
    
    func priceButtonCellTapped(for product: Product) {
        presenter?.priceButtonCellTapped(product)
    }
}

//  MARK: - Layout
private extension MenuController {
    
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
extension MenuController: UITableViewDataSource, UITableViewDelegate {
    
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
            return presenter?.products.count ?? 0
        default:
            return SectionRows.none
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = MenuSection.init(rawValue: indexPath.section)
        
        switch section {
        case .banner:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannerCell.reuseId, for: indexPath) as! BannerCell
            cell.update(products: presenter?.banners ?? [])
            cell.selectionStyle = .none
            
            cell.onBannerTapped = { banner in
                self.presenter?.bannerCellTapped(banner)
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
            
            cell.onPriceButtonCellTapped = { product in
                self.presenter?.priceButtonCellTapped(product)
            }
            if let selectedCategory = presenter?.selectedCategory, product.category == selectedCategory.category {
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
