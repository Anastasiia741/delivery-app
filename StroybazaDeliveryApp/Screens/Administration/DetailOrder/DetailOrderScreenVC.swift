//  DetailVC.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 15/8/23.

import UIKit
import Firebase
import FirebaseFirestore

protocol OrderStatusDelegate: AnyObject {
    func updateOrderStatus(orderID: String, newStatus: String)
}


final class DetailOrderScreenVC: UIViewController {
    
//  MARK: - Properties
    var user: NewUser?
    var selectOrder: Order?
    private let profileService = DBServiceProfile.shared
    private let orderService = DBServiceOrders.shared
    var orderStatusDelegate: OrderStatusDelegate?
//  MARK: - UI
    private let containerView = ContainerView()
    private let nameLabel = OrderDetailLabel(style: .name)
    private let emailLabel = OrderDetailLabel(style: .email)
    private let numberOrderDetailLabel = OrderDetailLabel(style: .numberOrder)
    private let addressLabel = OrderDetailLabel(style: .address)
    private let phoneNumberLabel = OrderDetailLabel(style: .phoneNumber)
    private let orderLabel = OrderDetailLabel(style: .order)
    private let amountLabel = OrderDetailLabel(style: .amount)
    private var changeStatusButton = DetailButton(style: .accept, highlightColor: .green.withAlphaComponent(0.5), releaseColor: .green.withAlphaComponent(0.7))
    private let scrollView = UIScrollView()
    private let verticalStackView = StackView(style: .vertical)
    
//  MARK: - Life Curcle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
        setupConstraints()
        setupActions()
       
        fetchUserProfile()
        fetchOrderDetails()
        fetchOrderStatus()
    }
}

//  MARK: - Event Handler
private extension DetailOrderScreenVC {
    func setupActions() {
        changeStatusButton.addTarget(self, action: #selector(buttonStatusTapped), for: .touchUpInside)
    }
}

//  MARK: - Bussunes logic
private extension DetailOrderScreenVC {
    func fetchUserProfile() {
        guard let userID = selectOrder?.userID else { return }
        profileService.getProfile(by: userID) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                self?.updateUserUI()
            case .failure(let error):
                print("Ошибка при получении профиля пользователя: \(error.localizedDescription)")
            }
        }
    }
    
    func updateUserUI() {
    nameLabel.text = "Имя: \(user?.name ?? "")"
    emailLabel.text = "Email: \(user?.email ?? "")"
    addressLabel.text = "Адрес: \(user?.address ?? "")"
    phoneNumberLabel.text = "Номер телефона: \(user?.phone ?? "")"
}
    
    func fetchOrderDetails() {
        if let order = selectOrder {
            self.addressLabel.text = "Адрес доставки: \(String(describing: user?.address) )"
            self.phoneNumberLabel.text = "Номер телефона: \(String(describing: user?.phone) )"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy \nВремя - HH:mm"
            let dateString = dateFormatter.string(from: order.date)
            
            numberOrderDetailLabel.text = "Дата - \(dateString)"
            let orderItemsText = formatOrderItemsText(for: order)
            orderLabel.text = "Заказы:\n\(orderItemsText)"
            
            amountLabel.text = "Сумма: \(order.cost) сом"
        }
    }
    
    func formatOrderItemsText(for order: Order) -> String {
        var itemsText = ""
        for position in order.positions {
            let itemText = "\(position.product.name): \(position.count) шт."
            if itemsText.isEmpty {
                itemsText = itemText
            } else {
                itemsText += "\n\(itemText)"
            }
        }
        return itemsText
    }
    
    func fetchOrderStatus() {
        if let orderID = selectOrder?.id {
            orderService.fetchOrderStatus(orderID: orderID) { [weak self] (status) in
                if let status = status {
                    self?.changeStatusButton.setTitle(status, for: .normal)
                } else {
                    print("Не удалось получить статус заказа.")
                }
            }
        }
    }
}


//  MARK: - Navigation
private extension DetailOrderScreenVC {
    
    @objc func buttonStatusTapped() {
        let alertController = UIAlertController(title: AlertMessage.orderStatus, message: AlertMessage.emptyMessage, preferredStyle: .alert)
        let statusOptions = OrderStatus.allCases.filter { $0 != .all }.map { $0.rawValue }
        for status in statusOptions {
            let action = UIAlertAction(title: status, style: .default) { [weak self] _ in
                self?.changeStatusButton.setTitle(status, for: .normal)
                if let orderID = self?.selectOrder?.id {
                    self?.orderService.updateOrderStatus(orderID: orderID, newStatus: status)
                    self?.orderStatusDelegate?.updateOrderStatus(orderID: orderID, newStatus: status)
                    
                }
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: AlertMessage.closelAction, style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

//  MARK: - Layout
private extension DetailOrderScreenVC {
    func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(numberOrderDetailLabel)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(emailLabel)
        verticalStackView.addArrangedSubview(addressLabel)
        verticalStackView.addArrangedSubview(scrollView)
        verticalStackView.addArrangedSubview(amountLabel)
        scrollView.addSubview(orderLabel)
        containerView.addSubview(changeStatusButton)
    }
    
    func setupStyles() {
        view.backgroundColor = .systemBackground
        title = Titles.detailProduct
        containerView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerView).inset(18)
        }
        
        numberOrderDetailLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        scrollView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(0)
        }
        
        orderLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        changeStatusButton.snp.makeConstraints { make in
            make.centerX.equalTo(verticalStackView)
            make.top.equalTo(verticalStackView.snp.bottom).offset(18)
            make.bottom.equalTo(containerView.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.equalTo(36)
            make.width.equalTo(200)
        }
    }
}
