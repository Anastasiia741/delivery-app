//  ProfileController.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 22/12/23.

import UIKit

protocol ProfileViewProtocol: AnyObject {
    func reloadTable()
    func saveAlert()
    func showAuthScreen()
}

final class ProfileController: UIViewController {
    
    public var presenter: ProfilePresenterProtocol?
    private let authService = DBServiceAuth.shared
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
}

private extension ProfileController {

    func setupActions() {
        exitButton.exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        let deletetapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteAccountButtonTapped))
        deleteAccountLabel.addGestureRecognizer(deletetapGestureRecognizer)
        
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func saveButtonTap(){
        presenter?.saveButtonTapped()
    }
    
    @objc func exitButtonTapped() {
        let alertController = UIAlertController(title: AlertMessage.exitTitle, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: AlertMessage.yesAction, style: .destructive) { [weak self] _ in
            self?.presenter?.logout()
        })
        alertController.addAction(UIAlertAction(title: AlertMessage.cancelAction, style: .cancel))
        present(alertController, animated: true)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func deleteAccountButtonTapped() {
        let alertController = UIAlertController(title: AlertMessage.deleteAccount, message: AlertMessage.deleteQuestion, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertMessage.cancelAction, style: .cancel))
        alertController.addAction(UIAlertAction(title: AlertMessage.deleteAction, style: .destructive) { [weak self] _ in
            self?.presenter?.deleteAccountButtonTapped()
            self?.deleteAlert()
        })
        self.present(alertController, animated: true)
    }
}

//  MARK: - Life Cycle
extension ProfileController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupViews()
        setupActions()
        setupConstraints()
        
        presenter?.fetchUserProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.fetchOrderHistory()
    }
}


extension ProfileController: ProfileViewProtocol, ProfileCellProtocol, ProfileContactProtocol {
    func textFieldDidChange(_ newProfile: NewUser) {
         
    }
    
   
    func didUpdateProfileInfo(_ name: String?, _ phone: String?) {
        presenter?.nameTF = name ?? ""
        presenter?.phoneTF = phone ?? ""
    }
    
    func didUpdateContactInfo(_ address: String?) {
        presenter?.addressTF = address ?? ""
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func showAuthScreen() {
        let authViewController = AuthModuleConfiguration().configure()
        
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
    
    func saveAlert() {
        let alert = UIAlertController(title: AlertMessage.createProduct, message: AlertMessage.emptyMessage, preferredStyle: .alert)
        let attributedStringForTitle = NSAttributedString(string: AlertMessage.createProduct, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        alert.setValue(attributedStringForTitle, forKey: "attributedTitle")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 1, green: 0.9389490485, blue: 0.9055544138, alpha: 1)
        alert.view.tintColor = UIColor.black
        let okAction = UIAlertAction(title: AlertMessage.okAction, style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }

    func deleteAlert() {
        let alert = UIAlertController(title: AlertMessage.deleteMessage, message: AlertMessage.emptyMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertMessage.okAction, style: .default) { [weak self] _ in
            self?.presenter?.logout()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}


//  MARK: - Layout
private extension ProfileController {
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
extension ProfileController: UITableViewDataSource, UITableViewDelegate {
    
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
            return presenter?.orders.count ?? 0
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
            cell.delegate = self
            if let profile = presenter?.profile {
                cell.configure(with: profile)
            }
            return cell
        case .address:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileContactCell.reuseId, for: indexPath) as! ProfileContactCell
            cell.selectionStyle = .none
            cell.delegate = self
            if let profile = presenter?.profile {
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
            guard let order = presenter?.orders[indexPath.row] else { return UITableViewCell() }
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
