//  CalculateOrder.swift
//  StroybazaDeliveryAppTests
//  Created by Анастасия Набатова on 30/1/24.

import XCTest
@testable import StroybazaDeliveryApp

final class CalculateOrder: XCTestCase {

    let orderService = OrderService()
    
    func testCalculatePrice() throws {
        let product1 = Product(id: 1, name: "Product 1", category: "category", detail: "", description: "", price: 10, quantity: 2)
        let product2 = Product(id: 2, name: "Product 2", category: "category", detail: "", description: "", price: 20, quantity: 1)
        
        orderService.productRepository.save([product1, product2])
        
        let (totalPrice, totalQuantity) = orderService.calculatePrice()
        
        XCTAssertEqual(totalPrice, 40, "Total price should be 40")
        XCTAssertEqual(totalQuantity, 3, "Total quantity should be 3")
    }
    
    func testUpdateProductQuantity() {
        
        let product = Product(id: 1, name: "Product", category: "category", detail: "", description: "", price: 10, quantity: 2)
        
        orderService.productRepository.save([product])
        
        let updatedProducts = orderService.update(product, 5)
        
        XCTAssertEqual(updatedProducts.first?.quantity, 5, "Product quantity should be updated to 5")
    }
    
    func testAddProduct() {
        let product =  Product(id: 1, name: "Product", category: "category", detail: "", description: "", price: 10, quantity: 2)
        let updatedProducts = orderService.addProduct(product)
        
        XCTAssertEqual(updatedProducts.count, 1, "Product should be added to the order")
        XCTAssertEqual(updatedProducts.first?.id, product.id, "Added product should have the same id")
    }
    
    func testRemoveProduct() {
        let product = Product(id: 1, name: "Product", category: "category", detail: "", description: "", price: 10, quantity: 2)
        
        _ = orderService.addProduct(product)
        
        let updatedProducts = orderService.removeProduct(product)
        
        XCTAssertEqual(updatedProducts.count, 0, "Product should be removed from the order")
    }
}
