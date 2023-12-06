//  ProductsService.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import Foundation
// Сервис - поставщик данных. Класс у которого запрашивают данные (api, user-dafauls etc.)
//https://apingweb.com/api/rest/d5fabe138cb9817d873bc93e26a4e8475/products
final class ProductsAPI {
    let session = URLSession.init(configuration: .default)
    var categories: [Category] = []
    var products: [Product] = []
    
    func fetchCategories(completion: @escaping ([Category]) -> Void) {
        // https://apingweb.com/api/rest/8f98cf34eb24d1a5fc20d478d859e4927/category
        var urlComponents = URLComponents.init()
        urlComponents.scheme = "https"
        urlComponents.host = "apingweb.com"
        urlComponents.path = "/api/rest/8f98cf34eb24d1a5fc20d478d859e4927/category"
        
        guard let url = urlComponents.url else { return }
        
        print(url)
        
        var request = URLRequest.init(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                
                switch response.statusCode {
                case 200..<300:
                    print("Success Status: \(response.statusCode)")
                    break
                default:
                    print("Status: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return }
            let decoder = JSONDecoder.init()
            do {
                print(Thread.current)
                let categories = try decoder.decode([Category].self, from: data)
                
                DispatchQueue.main.async {
                    print(Thread.current)
                    completion(categories)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchProducts(completion: @escaping ([Product]) -> Void) {
        //      https://apingweb.com/api/rest/8bbaf2b152e6bd46678b51bfc357fdd59/product
        var urlComponents = URLComponents.init()
        urlComponents.scheme = "https"
        urlComponents.host = "apingweb.com"
        urlComponents.path = "/api/rest/8bbaf2b152e6bd46678b51bfc357fdd59/product"
        
        guard let url = urlComponents.url else { return }
        
        print(url)
        
        var request = URLRequest.init(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                
                switch response.statusCode {
                case 200..<300:
                    print("Success Status: \(response.statusCode)")
                    break
                default:
                    print("Status: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return }
            let decoder = JSONDecoder.init()
            do {
                print(Thread.current)
                let posts = try decoder.decode([Product].self, from: data)
                
                DispatchQueue.main.async {
                    print(Thread.current)
                    completion(posts)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}



