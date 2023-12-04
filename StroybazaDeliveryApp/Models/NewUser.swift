//  AdminUser.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 12/9/23.

import Foundation
import FirebaseAuth

struct NewUser: Identifiable {
    
    let id: String
    var name: String
    var phone: String
    var address: String
    var email: String
    var image: String?
  
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["name"] = self.name
        repres["phone"] = self.phone
        repres["address"] = self.address
        repres["email"] = self.email
        repres["image"] = self.image
        
        return repres
    }
}
