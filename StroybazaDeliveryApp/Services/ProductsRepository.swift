//  ProductsRepository.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 7/8/23.

import Foundation

// Протокол - контенирует набор методов.

protocol ProductsRepositoryI {
    func save(_ products: [Product]) //сохраняем продукты
    func retrieve() -> [Product] //закдалываем их массивом
}

// Класс принял протокол - означает, что класс обязуется реализовать эти методы и через эти методы будем общаться с классом через интерфейсы
final class ProductsRepository: ProductsRepositoryI {
    
    private let encoder = JSONEncoder() //кодирует в бинарник
    private let decoder = JSONDecoder() //разкодирует
    
    private let key = "Products"
    
    //MARK: - Public methods
    func save(_ products: [Product]) { //метод сохранить
        
        //Array<Product> -> Data
        //массив кладем в бинарник и кодируем, бинарник кладем в UserDefaults
        do {
            let data = try encoder.encode(products)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    //retrieve - получить данные
    func retrieve() -> [Product] {  //метод получить
        
        //Data -> Array<Product>
        //вытаскиваем из UserDefaults бинарник
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            //раскодировали бинарник в массив
            let array = try decoder.decode(Array<Product>.self, from: data)
            return array
        } catch {
            print(error)
        }
        return []
    }
}
