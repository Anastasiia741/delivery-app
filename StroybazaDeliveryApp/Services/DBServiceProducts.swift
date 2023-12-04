//  DBServiceProducts.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 8/10/23.

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import SDWebImage


final class DBServiceProducts {
    
    static let shared = DBServiceProducts()
    private let db = Firestore.firestore()
    private let productCollection = Firestore.firestore().collection("products")
    private let storage = Storage.storage()
    var products: Product?
    var listenerRegistation: ListenerRegistration?
    
    init() {}
    
    //  MARK: - add collection in firebase
    func add(product: Product, completion: @escaping (Error?) -> Void) throws {
        try productCollection.addDocument(from: product) { error in
            completion(error)
        }
    }
    
    //MARK: - Fetch and monitor changes of products from firebase
    func fetchAllProducts(completion: @escaping (Result<([Product], [Category]), Error>) -> Void)  {
        DispatchQueue.global().async {
            self.listenerRegistation?.remove()
            self.listenerRegistation = self.db.collection("products").addSnapshotListener { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                var products: [Product] = []
                var categories: [Category] = []
                
                for document in querySnapshot!.documents {
                    if let product = try? document.data(as: Product.self) {
                        products.append(product)
                    }
                    if let category = try? document.data(as: Category.self) {
                        categories.append(category)
                    }
                }
                
                let arrayCategories = Array(Set(categories))
                
                var sortedCategories = arrayCategories.sorted { $0.category < $1.category }
                if let armatureIndex = sortedCategories.firstIndex(where: { $0.category == CategoryName.armature }) {
                    let armatureCategory = sortedCategories.remove(at: armatureIndex)
                    sortedCategories.insert(armatureCategory, at: 0)
                }
                
                DispatchQueue.main.async {
                    completion(.success((products, sortedCategories)))
                }
            }
        }
    }
    
    deinit {
        listenerRegistation?.remove()
        print("listener registation remove")
    }
    
    //MARK: - Сreate new product
    func create(product: Product, completion: @escaping (Error?) -> Void) {
        let newProduct = product
        newProduct.id = UUID().hashValue
        do {
            let newDocumentRef = try productCollection.addDocument(from: newProduct)
            newProduct.documentID = newDocumentRef.documentID
            
            print("Новый документ успешно создан. ID: \(newDocumentRef.documentID)")
            update(product: newProduct, completion: completion)
        } catch {
            print("Ошибка при создании нового документа. Error: \(error.localizedDescription)")
            completion(error)
        }
    }
    
    //MARK: - Update product content
    func update(product: Product, completion: @escaping (Error?) -> Void) {
        _ = "gs://souvenir-shop-716eb.appspot.com/productImages/default.jpg"
        let productID = product.id
        productCollection.whereField("id", isEqualTo: productID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Ошибка поиска документа по ID: \(productID). Ошибка: \(error.localizedDescription)")
                completion(error)
            } else if let snapshot = querySnapshot, !snapshot.isEmpty {
                let document = snapshot.documents.first
                let uniqueImageURL = "gs://souvenir-shop-716eb.appspot.com/productImages/\(productID).jpg"
                document?.reference.updateData([
                    "name": product.name,
                    "category": product.category,
                    "detail": product.detail,
                    "description": product.description,
                    "price": product.price,
                    "image": uniqueImageURL,
                    "quantity": product.quantity
                ]) { error in
                    if let error = error {
                        print("Ошибка обновления документа: \(productID). Ошибка: \(error.localizedDescription)")
                        completion(error)
                    } else {
                        print("Документ успешно обновлен. ID: \(productID)")
                        completion(nil)
                    }
                }
            } else {
                print("Документ с ID \(productID) не найден.")
                completion(error)
            }
        }
    }
    
    //MARK: - Upload image in firestore
    func upload(image: UIImage?, url: String, completion: @escaping (String?, Error?) -> Void) {
        
        //        if currentReachabilityStatus == .notReachable {
        //                    print("Нет подключения к сети интернет!")
        //                }
        //
        guard let image = image,
              let imageData = image.jpegData(compressionQuality: 0.5) else {
            
            completion(nil, nil)
            return
        }
        
        let fileName = UUID().uuidString + url + ".jpg"
        
        save(imageData: imageData, nameImg: fileName) { imageLink in
            if let imageLink = imageLink {
                completion(imageLink, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    //MARK: - Upload image in storage
    func save(imageData: Data, nameImg: String, completion: @escaping (_ imageLink: String?) -> Void) {
        let storageRef = storage.reference(forURL: "gs://souvenir-shop-716eb.appspot.com/productImages").child(nameImg)
        
        _ = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            
            if let error = error {
                print("Ошибка загрузки: ", error)
                completion(nil)
            } else {
                storageRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        completion(downloadURL.absoluteString)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    //MARK: - Update image
    func uploadImageToFirebase(_ image: UIImage, _ imageURL: String, completion: @escaping (String?) -> Void) {
        let imageRef = Storage.storage().reference(forURL: imageURL)
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            imageRef.putData(imageData, metadata: nil) { (_, error) in
                if let error = error {
                    print("Ошибка при загрузке нового изображения в Firebase Storage: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    print("Изображение успешно загружено по ссылке: \(imageURL)")
                    imageRef.downloadURL { (url, error) in
                        if let url = url {
                            let newImageURL = url.absoluteString
                            print("Новая ссылка на изображение: \(newImageURL)")
                            completion(newImageURL)
                        } else {
                            print("Ошибка при получении новой URL изображения: \(String(describing: error?.localizedDescription))")
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Upload New Image
    func uploadNewImage(_ selectedImage: UIImage, _ imageName: String, completion: @escaping (String?, Error?) -> Void) {
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.5) else {
            completion(nil, nil)
            return
        }
        let uniqueImageURL = "gs://souvenir-shop-716eb.appspot.com/productImages/"
        let storageRef = storage.reference(forURL: uniqueImageURL)
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Ошибка при загрузке нового изображения: ", error)
                completion(nil, error)
            } else {
                storageRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        completion(downloadURL.absoluteString, nil)
                    } else {
                        completion(nil, nil)
                    }
                }
            }
        }
    }
    
    //MARK: - Delete product content
    func delete(product: Product, completion: @escaping (Error?) -> Void) {
        let productID = product.id
        
        productCollection.whereField("id", isEqualTo: productID)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(error)
                } else {
                    for document in snapshot!.documents {
                        document.reference.delete { error in
                            completion(error)
                        }
                    }
                }
            }
    }
    
    //MARK: - Delete image
    func deleteImage(_ imageName: String, completion: @escaping (Error?) -> Void) {
        
        let storageRef = storage.reference(forURL: "gs://souvenir-shop-716eb.appspot.com/products/gs:/souvenir-shop-716eb.appspot.com/productImages").child(imageName)
        storageRef.delete { error in
            completion(error)
        }
    }
    
    //MARK: - Data parser in firebase
    func addAllProducts() {
        
        //        if let fileURL = Bundle.main.url(forResource: "Products", withExtension: "json") {
        //            do {
        //                let jsonData = try Data(contentsOf: fileURL)
        //                let products = try JSONDecoder().decode([Product].self, from: jsonData)
        //
        //                for product in products {
        //                    do {
        //                        try add(product: product) { error in
        //                            if let error {
        //                                print("Ошибка добавления Firestore: \(error)")
        //                            } else {
        //                                print("Добавлены продукты в Firestore: \(product.name)")
        //                            }
        //                        }
        //                        sleep(1)
        //
        //                    } catch {
        //                        print("Ошибка добавления Firestore: \(error)")
        //                    }
        //                }
        //            } catch {
        //                print("Ошибка парсинга JSON data: \(error)")
        //            }
        //        }
        
    }
    
}
