//  Position.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 14/9/23.

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ProductsPosition: Identifiable {
    var id: String
    var product: Product
    var count: Int
    
    var cost: Int {
        return product.price * self.count
    }
    
    var representation: [String: Any] {
        var repres = [String: Any]()
       
        repres["id"] = id
        repres["count"] = count
        repres["name"] = product.name
        repres["price"] = product.price
        repres["cost"] = self.cost

        return repres
    }
    
    internal init(id: String, product: Product, count: Int) {
        self.id = id
        self.product = product
        self.count = count
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        guard let id = data["id"] as? String else { return nil}
        guard let name = data["name"] as? String else { return nil}
        guard let price = data["price"] as? Int else { return nil}
        let product: Product = Product( id: 0, name: name, category: "", detail: "", description: "", price: price, image: "", quantity: 1)
        guard let count = data["count"] as? Int else { return nil}
        
        self.id = id
        self.product = product
        self.count = count
    }
}
