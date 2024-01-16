//  ViewController.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit
import FirebaseAuth

final class ProfileScreenVC: UIViewController {
    
//  MARK: Database
    private let authService = DBServiceAuth.shared
    private let databaseService = DBServiceOrders.shared
    private let databaseProfile = DBServiceProfile.shared
    //  MARK: Properties
    private var imageURL: String?
    private var selectedImage: UIImage?
    private var profile: NewUser?
    private var orders = [Order]()
    //  MARK: UI
    private let exitButton = ExitButtonView()
    private let deleteAccountLabel = MainTitleLabel(style: .deleteAccount)
    private lazy var saveButton = UIBarButtonItem(title: ButtonsName.save, style: .done, target: self, action: #selector(saveButtonTap))
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseId)
        tableView.register(ProfileContactCell.self, forCellReuseIdentifier: ProfileContactCell.reuseId)
        tableView.register(ProfileTitileOrderCell.self, forCellReuseIdentifier: ProfileTitileOrderCell.reuseId)
        tableView.register(ProfileOrderCell.self, forCellReuseIdentifier: ProfileOrderCell.reuseId)
        
        return tableView
    }()
    
    //  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupViews()
        setupActions()
        setupConstraints()
        
        fetchUserProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchOrderHistory()
    }
}

//  MARK: - Event Handler
private extension ProfileScreenVC {
    
    func setupAlert() {
        let alert = UIAlertController(title: AlertMessage.createProduct, message: AlertMessage.emptyMessage, preferredStyle: .alert)
        let attributedStringForTitle = NSAttributedString(string: AlertMessage.createProduct, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        alert.setValue(attributedStringForTitle, forKey: "attributedTitle")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 1, green: 0.9389490485, blue: 0.9055544138, alpha: 1)
        alert.view.tintColor = .systemBlack
        let okAction = UIAlertAction(title: AlertMessage.okAction, style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
        
    func logout() {
        authService.signOut { [weak self] result in
            switch result {
            case .success:
                self?.showAuthScreen()
            case .failure(let error):
                print("Ошибка при выходе: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func saveButtonTap() {
        guard var updatedProfile = profile else {
            print("Профиль пользователя не инициализирован")
            return
        }
        
        if let nameCell = tableView.cellForRow(at: IndexPath(row: SectionRows.none, section: ProfileSection.name.rawValue)) as? ProfileCell {
            updatedProfile.name = nameCell.nameTextField.text ?? TextMessage.empty
            updatedProfile.phone = nameCell.numberTextField.text ?? TextMessage.empty
        }
        
        if let addressCell = tableView.cellForRow(at: IndexPath(row: SectionRows.none, section: ProfileSection.address.rawValue)) as? ProfileContactCell {
            updatedProfile.address = addressCell.addressTextField.text ?? TextMessage.empty
        }
        saveProfile(updatedProfile)
    }
    
    @objc private func deleteAccountButtonTapped() {
        let alertController = UIAlertController(title: AlertMessage.deleteAccount, message: AlertMessage.deleteQuestion, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertMessage.cancelAction, style: .cancel))
        alertController.addAction(UIAlertAction(title: AlertMessage.deleteAction, style: .destructive) { [weak self] _ in
            self?.authService.deleteAccount { result in
                switch result {
                case .success:
                    print("Аккаунт успешно удален")
                    self?.logout()
                    self?.showAuthScreen()
                case .failure(let error):
                    print("Ошибка удаления аккаунта: \(error.localizedDescription)")
                }
            }
        })
        present(alertController, animated: true)
    }
}

//  MARK: - Business Logic
private extension ProfileScreenVC {
    func saveProfile(_ profile: NewUser) {
        if let email = authService.currentUser?.email {
            databaseProfile.setProfile(user: profile, email: email) { [weak self] result in
                switch result {
                case .success(let updatedProfile):
                    print("Данные профиля успешно обновлены")
                    self?.profile = updatedProfile
                    self?.tableView.reloadData()
                    self?.setupAlert()
                case .failure(let error):
                    print("Ошибка при сохранении данных профиля: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchUserProfile() {
        if let currentUser = authService.currentUser {
            let currentUserUID = currentUser.uid
            databaseProfile.getProfile(by: currentUserUID) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.profile = user
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Ошибка при получении данных пользователя: \(error.localizedDescription)")
                }
            }
        } else {
            showAuthScreen()
        }
    }
    
    func fetchOrderHistory() {
        databaseService.fetchOrderHistory(by: authService.currentUser?.uid) { [weak self] result in
            switch result {
            case .success(let orderHistory):
                self?.orders = orderHistory
                self?.orders.sort { $0.date > $1.date }
                self?.tableView.reloadData()
                print("Полученные заказы:")
                for order in orderHistory {
                    print("Заказ ID: \(order.id) Дата: \(order.date)")
                }
            case .failure(let error):
                print("Ошибка при получении истории заказов: \(error.localizedDescription)")
            }
        }
    }
}

//  MARK: - Navigation
private extension ProfileScreenVC {
    func setupActions() {
        exitButton.exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        let deletetapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteAccountButtonTapped))
        deleteAccountLabel.addGestureRecognizer(deletetapGestureRecognizer)
        
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func showAuthScreen() {
        let authViewController = AuthController()
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
    
    @objc func exitButtonTapped() {
        let alertController = UIAlertController(title: AlertMessage.exitTitle, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: AlertMessage.yesAction, style: .destructive) { [weak self] _ in
            
            self?.logout()
        })
        alertController.addAction(UIAlertAction(title: AlertMessage.cancelAction, style: .cancel))
        present(alertController, animated: true)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
}

//  MARK: - Layout
private extension ProfileScreenVC {
    func setupStyles() {
        self.navigationItem.title = Titles.profile
        view.backgroundColor = .systemBackground
        saveButton.tintColor = .systemBlack
    }
    
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(exitButton)
        view.addSubview(deleteAccountLabel)
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-150)
        }
        
        exitButton.snp.makeConstraints { make in
            make.bottom.equalTo(exitButton.snp.top)
            make.top.equalTo(tableView.snp.bottom).offset(20)
            
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        deleteAccountLabel.snp.makeConstraints { make in
            make.top.equalTo(exitButton.snp.bottom).offset(8)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
    }
}

//  MARK: - UITableView
extension ProfileScreenVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = ProfileSection.init(rawValue: section)
        switch section {
        case .name:
            return SectionRows.profile
        case .address:
            return SectionRows.profile
        case .titleOrders:
            return SectionRows.profile
        case .orders:
            return orders.count
        default:
            return SectionRows.none
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = ProfileSection.init(rawValue: indexPath.section)
        switch section {
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseId, for: indexPath) as! ProfileCell
            cell.selectionStyle = .none
            if let profile = self.profile {
                cell.configure(with: profile)
            }
            return cell
        case .address:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileContactCell.reuseId, for: indexPath) as! ProfileContactCell
            cell.selectionStyle = .none
            if let profile = self.profile {
                cell.configure(with: profile, email: authService.currentUser?.email ?? TextMessage.empty)
            }
            return cell
        case .titleOrders:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTitileOrderCell.reuseId, for: indexPath) as! ProfileTitileOrderCell
            cell.selectionStyle = .none
            return cell
        case .orders:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileOrderCell.reuseId, for: indexPath) as! ProfileOrderCell
            cell.selectionStyle = .none
            let order = orders[indexPath.row]
            cell.configure(with: order)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = ProfileSection.init(rawValue: indexPath.section)
        switch section {
        case .name:
            return CellHeight.profileName
        case .address:
            return CellHeight.profileAddress
        case .titleOrders:
            return CellHeight.profileTitleOrders
        case .orders:
            return CellHeight.profileOrders
        default:
            return CellHeight.profileDefault
        }
    }
}
