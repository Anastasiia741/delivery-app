//  ProductModuleConfigurator.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 27/12/23.

import Foundation

final class ProductEditModuleConfigurator {
    
    func configure() -> ProductEditController {
        let productVC = ProductEditController()
        let presenter = ProductEditPresenter()
        
        productVC.presenter = presenter
        presenter.view = productVC
        
        return productVC
    }
}
