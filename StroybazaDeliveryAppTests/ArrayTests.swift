//  ArrayTests.swift
//  StroybazaDeliveryAppTests
//  Created by Анастасия Набатова on 19/1/24.

import XCTest
@testable import StroybazaDeliveryApp

final class ArrayTests: XCTestCase {

    func testGetValueInRange() throws {
        let array = [1, 3, 5, 7, 10]
        let value = array[safe: 4]
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 10)
    }
    
    func testGetValueOutOfRange() throws {
        let array = [1, 3, 5, 7, 10]
        let value = array[safe: 20]
        XCTAssertNil(value)
    }
}
