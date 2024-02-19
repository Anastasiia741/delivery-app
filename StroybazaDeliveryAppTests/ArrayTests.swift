//
//  ArrayTests.swift
//  StroybazaDeliveryAppTests
//
//  Created by Анастасия Набатова on 19/1/24.
//

import XCTest
@testable import StroybazaDeliveryApp


final class ArrayTests: XCTestCase {

    func testGetValueInRange() throws { 
        // тест на успешное взятие элемента по индексу
        // Given
        let array = [1, 3, 5, 7, 10]
        
        // When
        let value = array[safe: 4]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 10)
    }
    
    func testGetValueOutOfRange() throws {
        // Given
        let array = [1, 3, 5, 7, 10]
        
        // When
        let value = array[safe: 20]
        
        // Then
        XCTAssertNil(value)
    }
}
