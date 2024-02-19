//
//  Array+save.swift
//  StroybazaDeliveryApp
//
//  Created by Анастасия Набатова on 19/1/24.
//

import Foundation
import FirebaseAuth


extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
