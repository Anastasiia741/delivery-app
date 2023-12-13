//  Categories.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 11/9/23.

import Foundation

struct Category: Codable, Comparable, Equatable, Hashable {
    
    static func < (lhs: Category, rhs: Category) -> Bool {
        lhs.category < rhs.category
    }
    
    let category: String
}
      
