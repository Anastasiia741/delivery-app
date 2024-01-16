//  AdminController.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 26/12/23.

import UIKit

protocol AdminViewProtocol {
    func reloadTable()
    func showMainMenu()
    func showOrderDetailScreen( _ order: Order)
}

final class AdminController: UIViewController {
    
    public var presenter: AdminPresenter?
//MARK: - Properties
    private var selectedStatus: OrderStatus = .all
    public let detailModuleConfigurator = DetailModuleConfigurator()
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
}

//  MARK: -  Life Cycle
extension AdminController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.fetchUserOrders()
    }
}

//  MARK: - Presentation Logic
extension AdminController: AdminViewProtocol {
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func showMainMenu() {
        let authViewController = AuthController()
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
    
    func showOrderDetailScreen( _ order: Order) {
        let viewController = detailModuleConfigurator.configure()
        viewController.presenter?.selectOrder = order
        navigationController?.navigationBar.tintColor = .buyButton
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//  MARK: - Event Handler
extension AdminController: AdminCellDelegate {
    
    func orderDetailsButtonTapped(order: Order) {
        showOrderDetailScreen(order)
    }
    
    @objc func exitBarButtonTapped() {
        let alertController = UIAlertController(title: AlertMessage.exitTitle, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: AlertMessage.yesAction, style: .destructive) { [weak self] _ in
            self?.presenter?.logout()
        })
        alertController.addAction(UIAlertAction(title: AlertMessage.cancelAction, style: .cancel))
        present(alertController, animated: true)
    }
}

//  MARK: - Layout
private extension AdminController {
    
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

//MARK: - UITableView
extension AdminController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.filteredOrders.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdminCell.reuseId, for: indexPath) as! AdminCell
        if let orders = presenter?.filteredOrders[indexPath.row] {
            cell.configure(orders)
        }
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AdminHeaderView.reuseId) as? AdminHeaderView
        
        headerView?.onButtonTapped = { [weak self] status in
            self?.presenter?.filterOrdersByStatus(status)
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
