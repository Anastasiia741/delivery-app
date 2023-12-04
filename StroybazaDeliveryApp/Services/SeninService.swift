//
//  SeninService.swift
//  CakeDeliveryApp
//
//  Created by Alexander Senin on 21.10.2023.
//

/*
 {
   "id": 163,
   "name": "FIYGHT",
   "category": "Н\u0430\u0431о\u0440ы",
   "detail": "\u0418\u0434\u0435\u0430льны\u0439 н\u0430\u0431о\u0440 \u0434ля \u0430к\u0442\u0438\u0432ны\u0445 \u0438 \u0441\u0442\u0438льны\u0445 лю\u0434\u0435\u0439 \u0432 по\u0434\u0430\u0440ок",
   "description": "\u0418\u0434\u0435\u0430льны\u0439 н\u0430\u0431о\u0440 \u0434ля \u0430к\u0442\u0438\u0432ны\u0445 \u0438 \u0441\u0442\u0438льны\u0445 лю\u0434\u0435\u0439 \u0432 по\u0434\u0430\u0440ок. \u0421о\u0431\u0440\u0430л\u0438\u0441ь \u0432 п\u0443\u0442\u0435\u0448\u0435\u0441\u0442\u0432\u0438\u0435? Н\u0443\u0436но \u0438м\u0435\u0442ь п\u0438 \u0441\u0435\u0431\u0435 \u0434\u0435нь\u0433\u0438, к\u0430\u0442\u0440ы, \u0434ок\u0443м\u0435н\u0442ы? Н\u0430\u0431о\u0440 FLIGHT, о\u0442л\u0438\u0447но\u0435 \u0440\u0435\u0448\u0435н\u0438\u0435! \n\u0412 н\u0430\u0431о\u0440\u0435: \n-\u0421\u0442\u0438льны\u0439 м\u0438н\u0438 \u0440юк\u0437\u0430к. \n- \u0423\u0434о\u0431ны\u0439 по\u0440\u0442мон\u0435. \n- \u0418м\u0435нно\u0439 \u0447\u0435\u0445ол \u0434ля \u0437\u0430\u0433\u0440\u0430нп\u0430\u0441по\u0440\u0442\u0430.",
   "price": 2000,
   "image": "gs://cake-delivery-app-477d8.appspot.com/picture/74.jpg",
   "quantity": 1
 }
 */


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift



class FirestoreProductManager {
    
    private let productCollection = Firestore.firestore().collection("products")
    
    /*
    func fetchAllProducts(completion: @escaping (Result<[Product], Error>)->Void)  {
        db.collection("products").getDocuments { querySnapshot, error in
            if let error {
                completion(.failure(error))
                return
            }
            let products = querySnapshot?.documents.compactMap({ queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Product.self)
            }) ?? []
            completion(.success(products))
        }
    }
    */
    
    var listenerRegistation: ListenerRegistration?
    func listenerForAllProducts(completion: @escaping (Result<[Product], Error>)->Void)  {
        listenerRegistation?.remove()
        listenerRegistation = productCollection.addSnapshotListener { querySnapshot, error in
            
            print("Something cahnges...")
            
            if let error {
                completion(.failure(error))
                return
            }
            let products = querySnapshot?.documents.compactMap({ queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Product.self)
            }) ?? []
            completion(.success(products))
        }
    }
    
    deinit {
        listenerRegistation?.remove()
    }

    
    func add(product: Product, completion: @escaping (Error?) -> Void) {
        _ = try? productCollection.addDocument(from: product) { error in
            completion(error)
        }
    }
    
//    func update(product: Product, completion: @escaping (Error?) -> Void) {
//        guard let docID = product.documentID else { return }
//        try? productCollection.document(docID).setData(from: product) { error in
//            completion(error)
//        }
//    }
//    
//    func delete(product: Product, completion: @escaping (Error?) -> Void) {
//        guard let docID = product.documentID else { return }
//        productCollection.document(docID).delete { error in
//            completion(error)
//        }
//    }
    
    
}


func addAllProducts() {
//    let data = try! Data(contentsOf: Bundle.main.url(forResource: "Products", withExtension: "json")!)
//    do {
//        let products = try JSONDecoder().decode([Product].self, from: data)
//        let FirebaseManager = FirebaseManager()
//        for p in products {
//            firestoreManager.add(product: p) { error in
//                if let error {
//                    print(error)
//                } else {
//                    print("Product added")
//                }
//            }
//        }
//        print(products)
//    } catch {
//        print(error)
//    }
    
}
 

