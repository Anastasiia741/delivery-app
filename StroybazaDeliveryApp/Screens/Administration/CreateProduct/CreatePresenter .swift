//  CreatePresenter .swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 29/12/23.

import UIKit

protocol CreatePresenterProtocol {
    var productName: String { get set }
    var productCategory: String { get set }
    var productPrice: Int { get set }
    var mainDescription: String { get set }
    var productDetail: String { get set }
    var imageURL: String? { get set }
    var selectedImage: UIImage? { get set }
    
    func createProduct(_ product: Product)
    func saveButtonTapped()
}

final class CreatePresenter {
    
    public var view: CreateViewProtocol?
    //  MARK: - Database
    private let productsDB = DBServiceProducts.shared
    //  MARK: - Propertiese
    var productName: String = ""
    var productCategory: String = ""
    var productPrice: Int = 0
    var mainDescription: String = ""
    var productDetail: String = ""
    var imageURL: String?
    var selectedImage: UIImage?
}

//  MARK: - CreatePresenterProtocol
extension CreatePresenter: CreatePresenterProtocol {
    
    func saveButtonTapped() {
        view?.startActivityIndicator()
        
        guard isInputValid() else {
            view?.stopActivityIndicator()
            view?.showWarningAlert()
            return
        }
        
        createNewProduct()
    }
    
    private func isInputValid() -> Bool {
        if productName.isEmpty || productCategory.isEmpty || String(productPrice).isEmpty || selectedImage == nil {
            return false
        }
        
        if imageURL == nil {
            return false
        }
        
        return true
    }
    
    private func createNewProduct() {
        let newProduct = makeNewProduct()
        
        if let selectedImage = selectedImage, let imageURL = imageURL {
            productsDB.upload(image: selectedImage, url: imageURL) { [weak self] uploadedImageURL, error in
                DispatchQueue.main.async {
                    self?.view?.stopActivityIndicator()
                }
                
                if let uploadedImageURL = uploadedImageURL {
                    newProduct.image = uploadedImageURL
                    print("Изображение успешно загружено")
                } else if let error = error {
                    print("Ошибка при загрузке изображения:", error.localizedDescription)
                    self?.view?.showErrorAlert()
                    return
                }
                
                self?.createProduct(newProduct)
            }
        } else {
            createProduct(newProduct)
        }
    }
    
    private func makeNewProduct() -> Product {
        return Product(
            id: 0,
            name: productName,
            category: productCategory,
            detail: productDetail,
            description: mainDescription,
            price: Int(productPrice),
            image: imageURL,
            quantity: 1
        )
    }
    
    func createProduct(_ product: Product) {
        productsDB.create(product: product) { [weak self] error in
            if let error = error {
                print("Ошибка создания продукта:", error.localizedDescription)
            } else {
                print("Продукт создан: \(product.name)")
                DispatchQueue.main.async {
                    self?.view?.showSuccessAlert()
                    self?.view?.clearTextFields()
                    self?.view?.showProductEditController()
                }
            }
        }
    }
}
