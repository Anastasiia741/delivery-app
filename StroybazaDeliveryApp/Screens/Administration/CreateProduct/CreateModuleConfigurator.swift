//  ModuleConfigurator.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 29/12/23.

import Foundation

final class CreateModuleConfigurator {
    func configure() -> CreateController {
        let createVC = CreateController()
        let presenter = CreatePresenter()
        
        createVC.presenter = presenter
        presenter.view = createVC
        
        return createVC
    }
}
