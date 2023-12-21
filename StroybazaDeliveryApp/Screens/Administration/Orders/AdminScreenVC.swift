//  AdminScreenVC.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 15/8/23.

import UIKit
import SnapKit

final class AdminScreenVC: UIViewController {
    
//  MARK: - Properties
    private var orders: [Order] = []
    private var filteredOrders: [Order] = []
    private var selectedStatus: OrderStatus = .all
//  MARK: - Service
    private let databaseService = DBServiceOrders.shared
//  MARK: - UI
    private lazy var exitBarButton: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: ButtonsName.exit), for: .normal)
        button.addTarget(self, action: #selector(exitBarButtonTapped), for: .touchUpInside)
        button.tintColor = .gray
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(AdminHeaderView.self, forHeaderFooterViewReuseIdentifier: AdminHeaderView.reuseId)
        tableView.register(AdminCell.self, forCellReuseIdentifier: AdminCell.reuseId)
        return tableView
    }()
    
//  MARK: - Life Cucle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchUserOrders()
    }
}

//  MARK: - Business Logic
extension AdminScreenVC {
    private func filterOrdersByStatus(_ status: OrderStatus) {
        selectedStatus = status
        switch status {
        case .all:
            filteredOrders = orders
        default:
            filteredOrders = orders.filter { $0.status == status.rawValue }
        }
        tableView.reloadData()
    }

    func fetchUserOrders() {
        databaseService.fetchUserOrders { [weak self] orders  in
            let sortedOrders = orders.sorted(by: { $0.date > $1.date })
            self?.orders = sortedOrders
            self?.filterOrdersByStatus(.all)
            self?.tableView.reloadData()
        }
    }
}

//  MARK: - Event Handler
extension AdminScreenVC: AdminCellDelegate, OrderStatusDelegate {
    func orderDetailsButtonTapped(order: Order) {
        showOrderDetailScreen(order)
    }
    
    func updateOrderStatus(orderID: String, newStatus: String) {
        if let index = orders.firstIndex(where: { $0.id == orderID }) {
            orders[index].status = newStatus
            filterOrdersByStatus(selectedStatus)
            tableView.reloadData()
        }
    }
}

//  MARK: - Navigation
private extension AdminScreenVC {
    func showOrderDetailScreen( _ order: Order) {
        let viewController = DetailOrderScreenVC()
        viewController.selectOrder = order
        navigationController?.navigationBar.tintColor = .buyButton
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showMainMenu() {
        let authViewController = AuthorizationScreenVC()
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
    
    func logout() {
        DBServiceAuth.shared.signOut { [weak self] result in
            switch result {
            case .success:
                self?.showMainMenu()
            case .failure(let error):
                print("Ошибка выхода: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func exitBarButtonTapped() {
        
        let alertController = UIAlertController(title: AlertMessage.exitTitle, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: AlertMessage.yesAction, style: .destructive) { [weak self] _ in
            self?.logout()
        })
        alertController.addAction(UIAlertAction(title: AlertMessage.cancelAction, style: .cancel))
        present(alertController, animated: true)
    }
}

//  MARK: - Layout
private extension AdminScreenVC {
    func setupViews() {
        self.navigationItem.rightBarButtonItem = exitBarButton
        view.addSubview(tableView)
    }
    
    func setupStyles() {
        view.backgroundColor = .systemBackground
        self.navigationItem.title = Titles.orderAdmin
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

//  MARK: - UITableView
extension AdminScreenVC: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdminCell.reuseId, for: indexPath) as! AdminCell
        let orders = filteredOrders[indexPath.row]
        cell.configure(orders)
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AdminHeaderView.reuseId) as? AdminHeaderView
        
        headerView?.onButtonTapped = { [weak self] status in
            self?.filterOrdersByStatus(status)
        }
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellHeight.adminOrders
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CellHeight.adminOrders
    }
}
