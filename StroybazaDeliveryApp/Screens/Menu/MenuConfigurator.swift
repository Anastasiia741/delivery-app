//  MenuConfigurator.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import Foundation

final class MenuModuleConfigurator {
    
    func configure() -> MenuController {
        let menuVC = MenuController()
        let presenter = MenuPresenter()
        
        menuVC.presenter = presenter
        presenter.view = menuVC
        
        return menuVC
    }
}
