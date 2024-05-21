//  EditPresenter.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 29/12/23.

import Foundation

protocol EditPresenterProtocol: AnyObject {
    var selectedProduct: Product? { get set }
    func updateProductInfo()
    func saveButtonTapped()
    func deleteSelectedProduct()
}

final class EditPresenter {
    weak var view: EditViewProtocol?
//  MARK: - Properties
    public var selectedProduct: Product? {
        didSet {
            view?.reloadTable()
        }
    }
    private let productsDB = DBServiceProducts.shared
    private var isImageChange = true
}

//  MARK: - Event handler
extension EditPresenter: EditPresenterProtocol {
    func updateProductInfo() {
        if selectedProduct != nil {
            view?.reloadTable()
        }
    }
    
    func deleteSelectedProduct() {
        guard let product = selectedProduct else {
            return
        }
        productsDB.delete(product: product) { [weak self] error in
            if error != nil {
            } else {
                self?.view?.showSuccessAlert()
            }
        }
    }
    
    func saveButtonTapped() {
        guard let selectedProduct = selectedProduct else { return }
        productsDB.update(product: selectedProduct) { [weak self] error in
            if error != nil {
            } else {
                self?.view?.showSuccessAlert()
                if self?.isImageChange == true {
                    guard let selectedImage = self?.view?.selectedImage, let imageURL = selectedProduct.image else { return }
                    self?.productsDB.uploadImageToFirebase(selectedImage, imageURL) { imageURL in
                        if let imageURL = imageURL {
                            self?.selectedProduct?.image = imageURL
                            self?.view?.showSuccessAlert()
                        } 
                    }
                }
            }
        }
    }
}



