//  ProductPresenter.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 19/12/23.

import Foundation
import FirebaseStorage
import UIKit

protocol ProductPresenterProtocol: AnyObject {
    func viewDidLoad()
    func orderButtonTapped()
}

final class ProductPresenter {
    weak var view: ProductViewProtocol?
    //  MARK: - Actions
    var selectedProduct: Product?
    //  MARK: - Properties
    private let orderService = OrderService()
}

//  MARK: - View Events
extension ProductPresenter {
    func viewDidLoad() {
        updateImageDetail()
        updateProductDetail()
    }
    
    @objc func orderButtonTapped() {
        let _ = orderService.addProduct(selectedProduct)
        self.view?.dismiss(animated: true)
    }
}

//  MARK: - Business Logic
extension ProductPresenter: ProductPresenterProtocol {
    
    func updateImageDetail() {
        if let product = selectedProduct {
            if let productImage = product.image {
                let imageRef = Storage.storage().reference(forURL: productImage)
                imageRef.downloadURL { [weak self] url, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let imageURL = url {
                            self?.view?.showProductImage(url: imageURL)
                        }
                    }
                }
            }
        }
    }
    
    func updateProductDetail() {
        if let product = selectedProduct {
            view?.showProduct(product: product)
        }
    }
}
