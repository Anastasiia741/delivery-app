//  CartScreenVC.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit

enum CartSection: Int, CaseIterable {
    case order, promoProducts
}

final class CartScreenVC: UIViewController {
    
    //  MARK: - Database
    private let productsDB = DBServiceProducts.shared
    //  MARK: - Properties
    private var products = [Product]()
    private var orderProducts = [Product]()
    private let productsRepository = ProductsRepository()
    //  MARK: - Services
    private let bannerAPI = BannerAPI()
    private let orderService = OrderService()
    //  MARK: - UI
    private let informView = InformView()
    private let promoView = PromoButtonView()
    private let orderView = OrderButtonView()
    private let productCountLabel = MainTitleLabel(style: .cartTitle)
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseId)
        tableView.register(PromoCell.self, forCellReuseIdentifier: PromoCell.reuseId)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        return tableView
    }()
    var alertController: UIAlertController?
    
    //  MARK: - Life Curcle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
        setupActions()
        setupConstraints()
        fetchPromoProducts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchOrder()
    }
}

//  MARK: - Navigation
private extension CartScreenVC {
    
    func showMenuScreen() {
        tabBarController?.selectedIndex = 0
    }
    
    func showEnterPromocodeAlert() {
        let alertController = UIAlertController(title: AlertMessage.promoTitle, message: AlertMessage.emptyMessage, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = AlertMessage.promoPlaceholder
        }
        let attributedStringForTitle = NSAttributedString(string: AlertMessage.promoTitle, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.202498883, green: 0.202498883, blue: 0.202498883, alpha: 1)])
        alertController.setValue(attributedStringForTitle, forKey: AlertMessage.promoKey)
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 1, green: 0.9389490485, blue: 0.9055544138, alpha: 1)
        alertController.view.tintColor = .black
        let cancelAction = UIAlertAction(title: AlertMessage.cancelAction, style: .cancel) { _ in }
        alertController.addAction(cancelAction)
        let applyAction = UIAlertAction(title: AlertMessage.applyAction, style: .default) {[weak self] _ in
            if let promoCode = alertController.textFields?.first?.text?.lowercased() {
                self?.applyPromocodeAlertTapped(promoCode)
            }
        }
        alertController.addAction(applyAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showPromocodeResultAlert(message: NSAttributedString) {
        let alertController = UIAlertController(title: AlertMessage.promoResult, message: "", preferredStyle: .alert)
        alertController.setValue(message, forKey: "attributedMessage")
        
        let attributedStringForTitle = NSAttributedString(string: AlertMessage.promoResult, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.202498883, green: 0.202498883, blue: 0.202498883, alpha: 1)])
        alertController.setValue(attributedStringForTitle, forKey: AlertMessage.promoKey)
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 1, green: 0.9389490485, blue: 0.9055544138, alpha: 1)
        alertController.view.tintColor = UIColor.black
        let okAction = UIAlertAction(title: AlertMessage.okAction, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAuthScreen() {
        let authViewController = AuthorizationScreenVC()
        present(authViewController, animated: true, completion: nil)
    }
    
    func setupActions() {
        promoView.promoButton.addTarget(self, action: #selector(promoButtonTapped), for: .touchUpInside)
        orderView.orderButton.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
    }
}

//  MARK: - Business Logic
private extension CartScreenVC {
    
    func fetchPromoProducts() {
        productsDB.fetchAllProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let products, _)):
                let bannerProducts = products.filter { $0.category == CategoryName.discount }
                self.products = bannerProducts
                self.tableView.reloadData()
            case .failure(let error):
                print("Ошибка при загрузке баннеров: \(error)")
            }
        }
    }
    
    func fetchOrder() {
        self.orderProducts = orderService.retreiveProducts()
        let (count, price) = orderService.calculatePrice()
        if count == 0 {
            productCountLabel.text = TextMessage.cardEmpty
        } else {
            productCountLabel.text = "\(price) товара на \(count) сом"
        }
        productsRepository.save(orderProducts)
        tableView.reloadData()
    }
    
    func addPromoProductToOrder(for product: Product) {
        print(product)
        let _ = orderService.addProduct(product)
        fetchOrder()
    }
}

//  MARK: - Event Handler
private extension CartScreenVC {
    
    func applyPromocodeAlertTapped(_ promoCode: String) {
        var discountMessage = AlertMessage.emptyMessage
        switch promoCode {
        case AlertMessage.promoCode10.lowercased():
            discountMessage = AlertMessage.promoDiscount10
        case AlertMessage.promoCode20.lowercased():
            discountMessage = AlertMessage.promoDiscount20
        case AlertMessage.promoCode30.lowercased():
            discountMessage = AlertMessage.promoDiscount30
        default:
            discountMessage = AlertMessage.discountMessage
        }
        let coloredMessage = NSAttributedString(string: discountMessage, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        showPromocodeResultAlert(message: coloredMessage)
        
        if let promoCode = alertController?.textFields?.first?.text?.lowercased() {
            self.orderService.promoсode = promoCode
            print("->\(promoCode)")
        }
    }
    
    @objc func promoButtonTapped() {
        showEnterPromocodeAlert()
    }
    
    @objc func orderButtonTapped() {
        if orderProducts.isEmpty {
            showMenuScreen()
        } else {
            if let currentUser = DBServiceAuth.shared.currentUser {
                var order = Order(id: UUID().uuidString, userID: currentUser.uid, positions: [], date: Date(), status: OrderStatus.new.rawValue, promocode: "")
                if let promocode = alertController?.textFields?.first?.text?.lowercased() {
                    self.applyPromocodeAlertTapped(promocode)
                    order.promocode = promocode
                    print("Promocode -->\(promocode)")
                }
                order.positions = orderProducts.map { position in
                    return ProductsPosition(id: UUID().uuidString, product: position, count: position.quantity)
                }
                if order.positions.isEmpty {
                    print("Ваш заказ пуст")
                } else {
                    DBServiceOrders.shared.saveOrder(order: order, promocode: order.promocode) { result in
                        switch result {
                        case .success(let order):
                            print("\(TextMessage.cardMessade) \(order.cost)")
                            self.orderProducts.removeAll()
                            self.tableView.reloadData()
                            self.productsRepository.save(self.orderProducts)
                            self.productCountLabel.text = TextMessage.cardOrder
                            self.showInformView()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                showAuthScreen()
            }
        }
    }
}

//  MARK: - Animation
private extension CartScreenVC {
    func showInformView() {
        informView.frame.origin.y = view.frame.height
        let heightInf = view.frame.height - informView.frame.height
        UIView.animate(withDuration: 0.5, delay: 1) {
            self.informView.frame.origin.y = heightInf - 150
            self.informView.alpha = 1.0
        }
        UIView.animate(withDuration: 1, delay: 2) {
            self.informView.alpha = 0.0
        }
    }
}

//MARK: - Layout
private extension CartScreenVC {
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(promoView)
        view.addSubview(orderView)
        view.addSubview(informView)
        view.addSubview(productCountLabel)
    }
    
    func setupStyles() {
        view.backgroundColor = .systemBackground
        self.navigationItem.title = Titles.cart
    }
    
    func setupConstraints() {
        productCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(productCountLabel.safeAreaLayoutGuide).offset(35)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-150)
        }
        
        promoView.snp.makeConstraints { make in
            make.bottom.equalTo(orderView.snp.top)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        orderView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view).inset(-2)
        }
        
        informView.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-100)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(100)
        }
    }
}

//  MARK: - UITableView
extension CartScreenVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        Sections.cart
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = CartSection.init(rawValue: section)
        switch section {
        case .order:
            return orderProducts.count
        case .promoProducts:
            return SectionRows.banner
        default:
            return SectionRows.none
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = CartSection.init(rawValue: indexPath.section)
        switch section {
        case .order:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseId, for: indexPath) as! CartCell
            let product = orderProducts[indexPath.row]
            cell.selectionStyle = .none
            cell.onProductChanged = { (product, count) in
                self.orderProducts = self.orderService.update(product, count)
                self.fetchOrder()
            }
            cell.update(product)
            return cell
        case .promoProducts:
            let cell = tableView.dequeueReusableCell(withIdentifier: PromoCell.reuseId, for: indexPath) as! PromoCell
            cell.update(products: products)
            cell.selectionStyle = .none
            cell.onPromoTapped = { product in
                self.addPromoProductToOrder(for: product)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = CartSection(rawValue: indexPath.section)
        switch section {
        case .promoProducts:
            _ = products[indexPath.row]
            fetchOrder()
        default:
            break
        }
    }
}
