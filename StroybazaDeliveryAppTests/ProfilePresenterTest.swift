//  ProfilePresenterTest.swift
//  StroybazaDeliveryAppTests
//  Created by Анастасия Набатова on 19/1/24.

import XCTest
@testable import StroybazaDeliveryApp
import FirebaseAuth

final class ProfilePresenterTest: XCTestCase {
    
    var profilePresenter: ProfilePresenter?
    var mockDBServiceAuth: MockDBServiceAuth?
    var mockDBServiceOrders: MockDBServiceOrders?
    var mockDBServiceProfile: MockDBServiceProfile?

    override init() {
        mockDBServiceAuth = MockDBServiceAuth()
        mockDBServiceOrders = MockDBServiceOrders()
        mockDBServiceProfile = MockDBServiceProfile()
        
        super.init()
        
        mockDBServiceAuth = MockDBServiceAuth()
        mockDBServiceOrders = MockDBServiceOrders()
        mockDBServiceProfile = MockDBServiceProfile()
            
      
    }
    
    
    override func tearDown() {
          // Ваши действия для очистки после теста
          profilePresenter = nil
          mockDBServiceAuth = nil
          mockDBServiceOrders = nil
          mockDBServiceProfile = nil
          
          super.tearDown()
      }

    
    
       func testFetchOrderHistory() {

           let mockedOrders = [
            Order(id: "order1",
                  userID: "ID1",
                  positions: [ProductsPosition(id: "1", product: Product(id: 0, name: "position1", category: "", detail: "", description: "", price: 0, image: "", quantity: 1), count: 1)],
                  date: Date(),
                  status: "Completed",
                  promocode: "mockedPromo"),
            
            Order(id: "order2",
                  userID: "ID2",
                  positions: [ProductsPosition(id: "2", product: Product(id: 1, name: "position2", category: "", detail: "", description: "", price: 0, image: "", quantity: 1), count: 1)],
                  date: Date(),
                  status: "New",
                  promocode: "mockedPromo"),
            
           ]

           mockDBServiceOrders?.mockedOrderHistory = mockedOrders
           profilePresenter?.fetchOrderHistory()

           XCTAssertEqual(profilePresenter?.orders, mockedOrders, "Orders should be equal")
       }
}
