//  ProductModuleConfigurator.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 19/12/23.

import Foundation

final class ProductModuleConfigurator {
    
    func configure() -> ProductController {
        let productVC = ProductController()
        let presenter = ProductPresenter()
        
        productVC.presenter = presenter
        presenter.view = productVC
        
        return productVC
    }
}
