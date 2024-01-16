//  DetailOrderController.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 26/12/23.

import UIKit

protocol DetailOrderViewProtocol {
    func showOrder(date: String, order: String, promocode: String,  amount: Int)
    func showUserInfo(name: String, email: String, address: String, phoneNumber: String)
    func showStatusButton(status: String)
}

final class DetailOrderController: UIViewController {
   
    public var presenter: DetailOrderPresenter?
    
//  MARK: - UI
    private let nameLabel = OrderDetailLabel(style: .name)
    private let emailLabel = OrderDetailLabel(style: .email)
    private let numberOrderDetailLabel = OrderDetailLabel(style: .numberOrder)
    private let addressLabel = OrderDetailLabel(style: .address)
    private let phoneNumberLabel = OrderDetailLabel(style: .phoneNumber)
    private let orderLabel = OrderDetailLabel(style: .order)
    private let promoLabel = OrderDetailLabel(style: .name)
    private let amountLabel = OrderDetailLabel(style: .amount)
    private var changeStatusButton = DetailButton(style: .accept, highlightColor: .green.withAlphaComponent(0.7), releaseColor: .green.withAlphaComponent(0.5))
    private let scrollView = UIScrollView()
    private let verticalStackView = StackView(style: .vertical)
}

//  MARK: - Life Cycle
extension DetailOrderController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
        setupConstraints()
        setupActions()
        
        presenter?.fetchUserProfile()
        presenter?.fetchOrderDetails()
        presenter?.fetchOrderStatus()
    }
}

//  MARK: - Event Handler
extension DetailOrderController {
  
    func setupActions() {
        changeStatusButton.addTarget(self, action: #selector(buttonStatusTapped), for: .touchUpInside)
    }
    
    @objc func buttonStatusTapped() {
        let alertController = UIAlertController(title: AlertMessage.orderStatus, message: AlertMessage.emptyMessage, preferredStyle: .alert)
        let statusOptions = OrderStatus.allCases.filter { $0 != .all }.map { $0.rawValue }
        for status in statusOptions {
            let action = UIAlertAction(title: status, style: .default) { [weak self] _ in
                self?.changeStatusButton.setTitle(status, for: .normal)
                if let orderID = self?.presenter?.selectOrder?.id {
                    self?.presenter?.buttonStatusTapped(orderID: orderID, newStatus: status)
                }
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: AlertMessage.closelAction, style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - Bussunes logic
extension DetailOrderController: DetailOrderViewProtocol {
   
    func showOrder(date: String, order: String, promocode: String, amount: Int) {
        numberOrderDetailLabel.text = "Дата - \(date)"
        orderLabel.text = "Товары:\n\(order)"
        promoLabel.text =  "Промокод: \(promocode)"
        amountLabel.text = "Сумма: \(amount) сом"
    }
    
    func showUserInfo(name: String, email: String, address: String, phoneNumber: String) {
        nameLabel.text = "Имя: \(name)"
        emailLabel.text = "Email: \(email)"
        addressLabel.text = "Адрес доставки: \(address)"
        phoneNumberLabel.text = "Номер телефона: \(phoneNumber)"
    }
    
    func showStatusButton(status: String) {
        changeStatusButton.setTitle(status, for: .normal)
    }
}

//  MARK: - Layout
private extension DetailOrderController {
    
    func setupViews() {
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(numberOrderDetailLabel)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(emailLabel)
        verticalStackView.addArrangedSubview(phoneNumberLabel)
        verticalStackView.addArrangedSubview(addressLabel)
        verticalStackView.addArrangedSubview(scrollView)
        verticalStackView.addArrangedSubview(promoLabel)
        verticalStackView.addArrangedSubview(amountLabel)
        scrollView.addSubview(orderLabel)
        view.addSubview(changeStatusButton)
    }
    
    func setupStyles() {
        title = Titles.detailProduct
        view.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func setupConstraints() {
        verticalStackView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(18)
            make.bottom.equalTo(changeStatusButton.snp.top).offset(-10)
        }
        
        scrollView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(0)
        }
        
        orderLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        changeStatusButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-18)
            make.centerX.equalTo(view)
            make.height.equalTo(36)
            make.width.equalTo(200)
        }
    }
}
