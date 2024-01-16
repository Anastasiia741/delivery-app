//  DetailModuleConfigurator.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 26/12/23.

import Foundation

final class DetailModuleConfigurator {
   
    func configure() -> DetailOrderController {
        let detailVC = DetailOrderController()
        let presenter = DetailOrderPresenter()
        
        detailVC.presenter = presenter
        presenter.view = detailVC
        
        return detailVC
    }
}
