//  CartController.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 19/12/23.

import UIKit
import SnapKit

protocol CartViewProtocol: AnyObject {
    func reloadTable()
    func showMenuScreen()
    func showInformView()
    func showAuthScreen()
    func showCountLable(message: String)
 }

final class CartController: UIViewController {
    
    public var presenter: CartPresenterProtocol?
//  MARK: - UI
    public let informView = InformView()
    private var productCountLabel = MainTitleLabel(style: .cartTitle)
    private let promoView = PromoButtonView()
    private let orderView = OrderButtonView()
    private var promoCode: String = ""
    private var alertController = UIAlertController()
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
}


extension CartController: CartViewProtocol {
    func reloadTable() {
        tableView.reloadData()
    }
    
    func sendPromocode(promocode: String) {
        promoCode = promocode
    }
    
    func showCountLable(message: String) {
        productCountLabel.text = message
    }
}

//  MARK: - Alert Actions
extension CartController {
    func showEnterPromocodeAlert() {
        alertController = UIAlertController(title: AlertMessage.promoTitle, message: AlertMessage.emptyMessage, preferredStyle: .alert)
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
            if let promoCode = self?.alertController.textFields?.first?.text?.lowercased() {
                self?.applyPromocodeAlertTapped(promoCode)
            }
        }
        alertController.addAction(applyAction)
        present(alertController, animated: true, completion: nil)
    }
    
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
        if let promoCode = alertController.textFields?.first?.text?.lowercased() {
            sendPromocode(promocode: promoCode)
        }
    }
    
    func showPromocodeResultAlert(message: NSAttributedString) {
        let alertController = UIAlertController(title: AlertMessage.promoResult, message: AlertMessage.emptyMessage, preferredStyle: .alert)
        alertController.setValue(message, forKey: "attributedMessage")
        let attributedStringForTitle = NSAttributedString(string: AlertMessage.promoResult, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.202498883, green: 0.202498883, blue: 0.202498883, alpha: 1)])
        alertController.setValue(attributedStringForTitle, forKey: AlertMessage.promoKey)
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 1, green: 0.9389490485, blue: 0.9055544138, alpha: 1)
        alertController.view.tintColor = UIColor.black
        let okAction = UIAlertAction(title: AlertMessage.okAction, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

//   MARK: -  Life Cycle
extension CartController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
        setupActions()
        setupConstraints()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.fetchOrder()
    }
}

//  MARK: - Animation
extension CartController {
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

//  MARK: - Event Handler
extension CartController {
    internal func showMenuScreen() {
        tabBarController?.selectedIndex = 0
    }
    
    func setupActions() {
        promoView.promoButton.addTarget(self, action: #selector(promoButtonTapped), for: .touchUpInside)
        orderView.orderButton.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
    }
    
    func showAuthScreen() {
        let authViewController = AuthController()
        present(authViewController, animated: true, completion: nil)
    }
    
    @objc func promoButtonTapped() {
        showEnterPromocodeAlert()
    }
    
    @objc func orderButtonTapped() {
        presenter?.orderButtonTapped(with: promoCode)
    }
}

//  MARK: - Layout
private extension CartController {
    
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

//  MARK: - UITableViewDelegate, UITableViewDataSource
extension CartController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Sections.cart
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = CartSection.init(rawValue: section)
        switch section {
        case .order:
            return presenter?.orderProducts.count ?? 0
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
            guard let product = presenter?.orderProducts[indexPath.row] else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.onProductChanged = { [weak self] (product, count) in
                guard let self = self else { return }
                if let updatedProducts = self.presenter?.orderService.update(product, count) {
                    self.presenter?.orderProducts = updatedProducts
                    self.presenter?.fetchOrder()
                }
            }
            cell.update(product)
            
            return cell
        case .promoProducts:
            let cell = tableView.dequeueReusableCell(withIdentifier: PromoCell.reuseId, for: indexPath) as! PromoCell
            cell.update(products: presenter?.products ?? [])
            cell.selectionStyle = .none
            cell.onPromoTapped = { product in
                self.presenter?.addPromoProductToOrder(for: product)
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = CartSection.init(rawValue: indexPath.section)
        switch section {
        case .promoProducts:
            _ = presenter?.products[indexPath.row]
            presenter?.fetchOrder()
        default:
            break
        }
    }
}
