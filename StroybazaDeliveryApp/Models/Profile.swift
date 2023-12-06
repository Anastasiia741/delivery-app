//  Profile.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 13/9/23.

import Foundation
import FirebaseFirestore

class Profile: ObservableObject {
    
    public var profile: NewUser
    public var orders: [Order] = [Order]()
    
    init(profile: NewUser, imageURL: String? = nil) {
        self.profile = profile
        self.profile.image = imageURL

    }
}

