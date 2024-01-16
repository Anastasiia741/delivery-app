//  CartModuleConfigurator.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 19/12/23.

import Foundation


final class CartModuleConfigurator {
    
    func configure() -> CartController {
        let cartVC = CartController()
        let presenter = CartPresenter()
        
        cartVC.presenter = presenter
        presenter.view = cartVC
        
        return cartVC
    }
}

