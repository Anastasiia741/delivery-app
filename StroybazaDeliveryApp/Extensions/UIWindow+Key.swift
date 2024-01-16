//
//  UIWindow+Key.swift
//  StroybazaDeliveryApp
//
//  Created by Анастасия Набатова on 15/1/24.
//

import Foundation
import UIKit


extension UIWindow {
    
    static var key: UIWindow! {
        if #available(iOS 13, *) {
            return UIApplication
                    .shared
                    .connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first { $0.isKeyWindow }
            
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
