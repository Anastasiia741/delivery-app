//  EditDetailProductScreenVC.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 22/8/23.

import UIKit
import SnapKit

final class EditDetailProductScreenVC: UIViewController {
    
//  MARK: - Properties
    var selectedProduct: Product?
    private var selectedImage: UIImage?
    private let productsDB = DBServiceProducts.shared
//  MARK: - UI
    private let horizontalStack = StackView(style: .horizontal)
    private var removeButton = OrderButton(style: OrderButtonType.remove,
                                           highlightColor: .blue.withAlphaComponent(0.7) ,
                                           releaseColor: .blue.withAlphaComponent(0.5))
    private var saveButton = OrderButton(style: OrderButtonType.save,
                                         highlightColor: .buyButton?.withAlphaComponent(0.7) ?? UIColor.red,
                                         releaseColor: .buyButton?.withAlphaComponent(0.5) ?? UIColor.red)
    private var isImageChange = true
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(EditProductImageCell.self, forCellReuseIdentifier: EditProductImageCell.reuseId)
        tableView.register(EditProductNameCell.self, forCellReuseIdentifier: EditProductNameCell.reuseId)
        tableView.register(EditProductDetailCell.self, forCellReuseIdentifier: EditProductDetailCell.reuseId)
        
        return tableView
    }()

//  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
        setupAction()
        setupConstraints()
        updateProductInfo()
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

//  MARK: - Bussiness logic
private extension EditDetailProductScreenVC {
    func updateProductInfo() {
        if selectedProduct != nil {
            tableView.reloadData()
        }
    }
}

//  MARK: -  Keyboard observe
private extension EditDetailProductScreenVC {
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
private extension EditDetailProductScreenVC {
    func setupAction() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: AlertMessage.updateProductTitle, message: AlertMessage.updateProductMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertMessage.okAction, style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showDeleteAlert() {
        let alertController = UIAlertController(title: AlertMessage.deleteProductTitle, message: AlertMessage.deleteProductMessage, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: AlertMessage.yesAction, style: .destructive) { [weak self] (_) in
            self?.deleteSelectedProduct()
        }
        let cancelAction = UIAlertAction(title: AlertMessage.noAction, style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}

//  MARK: - RemoveProduct
private extension EditDetailProductScreenVC {
    
    func deleteSelectedProduct() {
    guard let product = selectedProduct else {
        return
    }
    
    productsDB.delete(product: product) { [weak self] error in
        if let error = error {
            print("Ошибка удаления продукта: \(error.localizedDescription)")
        } else {
            print("Товар успешно удален")
            self?.showSuccessAlert()
        }
    }
}
    
    @objc func removeButtonTapped() {
        showDeleteAlert()
    }
}

//  MARK: - EditProductDelegate
extension EditDetailProductScreenVC: EditProductDelegate, EditProductDescriptionDelegate, EditProductNameDelegate {
    
    func didSelectImage(_ imageURL: String?, _ image: UIImage) {
        selectedProduct?.image = imageURL
        selectedImage = image
    }
    
    func didUpdateProductInfo(name: String, category: String, price: Int) {
        selectedProduct?.name = name
        selectedProduct?.category = category
        selectedProduct?.price = price
    }
    
    func didUpdateProductInfo(_ descriptionForMain: String, _ descriptionForDetail: String) {
        selectedProduct?.detail = descriptionForMain
        selectedProduct?.description = descriptionForDetail
    }
    
    @objc func saveButtonTapped() {
        guard let selectedProduct = selectedProduct else { return }
        
        productsDB.update(product: selectedProduct) { [weak self] error in
            if let error = error {
                print("Ошибка при обновлении данных: \(error.localizedDescription)")
            } else {
                print("Данные сохранены: \(selectedProduct)")
                self?.showSuccessAlert()
                
                if self?.isImageChange == true {
                    guard let selectedImage = self?.selectedImage else { return }
                    let imageURL = selectedProduct.image ?? ""
                    self?.productsDB.uploadImageToFirebase(selectedImage, imageURL) { newImageURL in
                        if newImageURL != nil {
                            self?.selectedProduct?.image = imageURL
                            self?.showSuccessAlert()
                        } else {
                            print("Ошибка при загрузке изображения.")
                        }
                    }
                }
            }
        }
    }
}

//  MARK: - Layout
private extension EditDetailProductScreenVC {
    
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(removeButton)
        horizontalStack.addArrangedSubview(saveButton)
        
    }
    
    func setupStyles() {
        view.backgroundColor = .systemBackground
    }
    
    func setupConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(saveButton.snp.top)
        }
        
        horizontalStack.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
}

//MARK: - TableViewDelegate, TableViewDataSource
extension EditDetailProductScreenVC:  UITableViewDelegate, UITableViewDataSource {
    
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
        return CreateProductSection.allCases.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: EditProductImageCell.reuseId, for: indexPath) as! EditProductImageCell
            cell.selectedProduct = selectedProduct
            cell.delegate = self
            cell.updateProductDetail()
            cell.selectionStyle = .none
            
            return cell
            
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: EditProductNameCell.reuseId, for: indexPath) as! EditProductNameCell
            cell.selectedProduct = selectedProduct
            cell.updateProductDetail()
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
            
        case .detail:
            let cell = tableView.dequeueReusableCell(withIdentifier: EditProductDetailCell.reuseId, for: indexPath) as! EditProductDetailCell
            cell.selectedProduct = selectedProduct
            cell.updateProductDetail()
            cell.selectionStyle = .none
            cell.delegate = self
            
            return cell
            
        case .none:
            fatalError("Случай необработанной секции: \(String(describing: section))")
        }
    }
}

