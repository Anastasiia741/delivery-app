//  ProfileModuleConfigurator.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 22/12/23.

import Foundation

final class ProfileModuleConfigurator {
    
    func configure() -> ProfileController {
        let profileVC = ProfileController()
        let presenter = ProfilePresenter()
        
        profileVC.presenter = presenter
        presenter.view = profileVC
        
        return profileVC
    }
}
