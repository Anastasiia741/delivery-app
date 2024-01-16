//  AuthModuleConfiguration.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 14/12/23.

import Foundation

final class AuthModuleConfiguration {
    
    func configure() -> AuthController {
        let authVC = AuthController()
        let presenter = AuthPresenter()
        
        authVC.presenter = presenter
        presenter.view = authVC
        
        return authVC
    }
}
