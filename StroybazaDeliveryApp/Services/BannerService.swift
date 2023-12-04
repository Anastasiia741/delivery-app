//  BannerService.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import Foundation

final class BannerAPI {
    
    let session = URLSession.init(configuration: .default)
    
    func fetchProducts(completion: @escaping ([Product]) -> Void) {
        // https://apingweb.com/api/rest/fa4b1d8fbe727d06a489c7937ff9e3a33/banners
        var urlComponents = URLComponents.init()
        urlComponents.scheme = "https"
        urlComponents.host = "apingweb.com"
        urlComponents.path = "/api/rest/fa4b1d8fbe727d06a489c7937ff9e3a33/banners"
        
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

