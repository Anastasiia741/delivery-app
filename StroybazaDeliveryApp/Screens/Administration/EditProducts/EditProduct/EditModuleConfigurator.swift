//  EditModuleConfigurator.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 29/12/23.

import Foundation

final class EditModuleConfigurator {
    
    func configure() -> EditController {
        let editVC = EditController()
        let presenter = EditPresenter()
        
        editVC.presenter = presenter
        presenter.view = editVC
        
        return editVC
    }
}
