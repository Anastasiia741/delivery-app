//  Product.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 6/12/23.

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
  
enum CodingKeys: String, CodingKey {
    case id, category, name, detail, description, price, image, imageUrl, quantity
}

class Product: Codable {
    @DocumentID var documentID: String?
    var id = UUID().hashValue
    var name: String
    var category: String
    var detail: String
    var description: String
    var price: Int
    var image: String?
    var quantity: Int = 1

    private enum CodingKeys: String, CodingKey {
        case name, id, category, detail, description, price, image, quantity
    }
    
    init(id: Int, name: String, category: String, detail: String, description: String, price: Int, image: String? = nil, quantity: Int) {
        self.id = id
        self.name = name
        self.category = category
        self.detail = detail
        self.description = description
        self.price = price
        self.image = image
        self.quantity = quantity
    }
}
