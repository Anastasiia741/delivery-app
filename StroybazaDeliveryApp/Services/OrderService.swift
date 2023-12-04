//  OrderService.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 25/8/23.

import Foundation

final class OrderService {
    
    let productRepository = ProductsRepository()
    var promoсode: String = ""
    
    func calculatePrice() -> (Int, Int) {
        var totalPrice = 0
        var totalQuantity = 0
        let products = productRepository.retrieve()
        
        for product in products {
            totalQuantity += product.quantity
            totalPrice += product.price * product.quantity
        }
        
        return (totalPrice, totalQuantity)
    }
    
    func retreiveProducts() -> [Product] {
        return productRepository.retrieve()
    }
    
    func update(_ product: Product, _ count: Int) -> [Product] {
        
        var products = productRepository.retrieve()
        
        for (index, item) in products.enumerated() {
            if item.id == product.id {
                products[index].quantity = count
                
                if count == 0 {
                    products.remove(at: index)
                }
                productRepository.save(products)
                break
            }
        }
        
        return products
    }
    
    func addProduct(_ product: Product?) -> [Product] {
        
        guard let product = product else { return [] }
        var products = productRepository.retrieve()
        
        for (index, item) in products.enumerated() {
            if item.id == product.id {
                products[index].quantity += 1
                productRepository.save(products)
                return products
            }
        }
        
        products.append(product)
        productRepository.save(products)
        
        print(products)
        return products
    }
    
    func removeProduct(_ product: Product) -> [Product] {
        
        var products = productRepository.retrieve()
        for (index, item) in products.enumerated() {
            if item.id == product.id {
                products.remove(at: index)
                productRepository.save(products)
            }
        }
        return products
    }
    
}
