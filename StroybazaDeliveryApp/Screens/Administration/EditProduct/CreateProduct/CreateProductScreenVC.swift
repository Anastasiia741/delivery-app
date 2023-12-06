//  createProductScreenVC.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 22/8/23.

import UIKit

enum CreateProductSection: Int, CaseIterable {
    case  image, name, detail
}

final class CreateProductScreenVC: UIViewController {
    
    //MARK: - Database
    private let productsDB = DBServiceProducts.shared
    
    //MARK: - Propertiese
    private var productName: String = ""
    private var category: String = ""
    private var price: Int = 0
    private var mainDescription: String = ""
    private var detail: String = ""
    private var imageURL: String?
    private var selectedImage: UIImage?
    
    //MARK: - UI
    private let saveView = OrderButton(style: OrderButtonType.save,
                                       highlightColor: UIColor(named: "BuyButton")?.withAlphaComponent(0.7) ?? UIColor.red,
                                       releaseColor: UIColor(named: "BuyButton")?.withAlphaComponent(0.5) ?? UIColor.red)
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(CreateProductImageCell.self, forCellReuseIdentifier: CreateProductImageCell.reuseId)
        tableView.register(CreateProductNameCell.self, forCellReuseIdentifier: CreateProductNameCell.reuseId)
        tableView.register(CreateProductDetailCell.self, forCellReuseIdentifier: CreateProductDetailCell.reuseId)
        
        return tableView
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupAction()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboard()
    }
}

//MARK: -  Keyboard observe
private extension CreateProductScreenVC {
    
    func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = -keyboardSize.height
        }
    }
    
    func removeKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
}

//MARK: - Navigation
private extension CreateProductScreenVC {
    
    func setupAction() {
        saveView.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: AlertMessage.createProduct, message: AlertMessage.createProductMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertMessage.okAction, style: .default, handler: { [weak self] _ in
            self?.tabBarController?.selectedIndex = 1
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showWarningAlert() {
        let alertController = UIAlertController(title: AlertMessage.createProductWarning, message: AlertMessage.createProductWarningMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertMessage.createProductWarningContinue, style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: AlertMessage.createProductWarningBack, style: .cancel) { [weak self] _ in
            self?.tabBarController?.selectedIndex = 1
        })
        present(alertController, animated: true, completion: nil)
        return
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: AlertMessage.errorTitle, message: AlertMessage.errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertMessage.okAction, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
}

//MARK: - EditProductDelegate
extension CreateProductScreenVC: CreateProductDelegate, CreateProductNameDelegate, CreateProductDescriptionDelegate {
    
    func didSelectImage(_ image: UIImage?, _ imageURL: String) {
        if let image = image {
            self.selectedImage = image
        }
        
        if !imageURL.isEmpty {
            self.imageURL = imageURL
        }
    }
    
    func didUpdateProductInfo(_ name: String, _ category: String, _ price: String) {
        self.productName = name
        self.category = category
        self.price = Int(price) ?? 0
    }
    
    func didUpdateProductInfo(_ descriptionForMain: String, _ descriptionForDetail: String) {
        self.mainDescription = descriptionForMain
        self.detail = descriptionForDetail
    }
}

//MARK: - Save product
extension CreateProductScreenVC {
    
    func createProduct(_ product: Product) {
        productsDB.create(product: product) { [weak self] error in
            if let error = error {
                print("Ошибка создания продукта:", error.localizedDescription)
            } else {
                print("Продукт создан: \(product.name)")
                
                DispatchQueue.main.async {
                    self?.showSuccessAlert()
                    self?.clearTextFields()
                    let productScreenVC = ProductScreenVC()
                    self?.navigationController?.pushViewController(productScreenVC, animated: true)
                }
            }
        }
    }
    
    func clearTextFields() {
        productName = ""
        category = ""
        price = 0
        detail = ""
        mainDescription = ""
        imageURL = ""
        selectedImage = nil
        
        if let imageCell = tableView.cellForRow(at: IndexPath(row: 0, section: CreateProductSection.image.rawValue)) as? CreateProductImageCell {
            imageCell.imageDidChange()
        }
        if let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: CreateProductSection.name.rawValue)) as? CreateProductNameCell {
            nameCell.clearNameTextField()
        }
        if let detailCell = tableView.cellForRow(at: IndexPath(row: 0, section: CreateProductSection.detail.rawValue)) as? CreateProductDetailCell {
            detailCell.clearDescTextView()
        }
    }
    
    @objc private func saveButtonTapped() {
        activityIndicator.startAnimating()
        
        guard !productName.isEmpty, !category.isEmpty, !detail.isEmpty, !String(price).isEmpty, !((imageURL?.isEmpty) == nil) else {
            activityIndicator.stopAnimating()
            return showWarningAlert()
        }
        
        if imageURL == nil {
            activityIndicator.stopAnimating()
            return showWarningAlert()
        }
        
        let newProduct = Product(
            id: 0,
            name: productName,
            category: category,
            detail: detail,
            description: mainDescription,
            price: Int(price),
            image: imageURL,
            quantity: 1
        )
        
        if let selectedImage = selectedImage,  let imageURL = imageURL {
            productsDB.upload(image: selectedImage, url: imageURL) { [weak self] imageURL, error in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
                
                if let imageURL = imageURL {
                    newProduct.image = imageURL
                    print("Изображение успешно загружено")
                    
                    self?.createProduct(newProduct)
                } else if let error = error {
                    print("Ошибка при загрузке изображения:", error.localizedDescription)
                    self?.showErrorAlert()
                }
            }
        } else {
            self.createProduct(newProduct)
        }
    }
}

//MARK: - Layout
private extension CreateProductScreenVC {
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(saveView)
        view.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(saveView.snp.top)
            
        }
        
        saveView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(18)
            make.left.right.equalToSuperview().inset(20)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
}

// MARK: - TableViewDataSource, TableViewDelegate
extension CreateProductScreenVC: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = CreateProductSection.init(rawValue: indexPath.section)
        
        switch section {
        case .image:
            return CellHeight.adminImage
        default:
            return UITableView.automaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        CreateProductSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = CreateProductSection.init(rawValue: section)
        
        switch section {
        case .image:
            return SectionRows.createProduct
        case .name:
            return SectionRows.createProduct
        case .detail:
            return SectionRows.createProduct
        default:
            return SectionRows.none
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = CreateProductSection.init(rawValue: indexPath.section)
        switch section {
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateProductImageCell.reuseId, for: indexPath) as! CreateProductImageCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateProductNameCell.reuseId, for: indexPath) as! CreateProductNameCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case .detail:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateProductDetailCell.reuseId, for: indexPath) as! CreateProductDetailCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case .none:
            fatalError("Случай необработанной секции: \(String(describing: section))")
            
        }
    }
}
