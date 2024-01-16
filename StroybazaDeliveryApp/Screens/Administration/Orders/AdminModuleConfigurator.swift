//  AdminModuleConfigurator.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 26/12/23.

import Foundation

final class AdminModuleConfigurator {
    
    func configure() -> AdminController {
        let adminVC = AdminController()
        let presenter = AdminPresenter()
        
        adminVC.presenter = presenter
        presenter.view = adminVC
        
        return adminVC
    }
}
