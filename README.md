# Stroybaza Delivery App 🛠️🏡📲
Welcome to online store for construction and renovation! This mobile application provides a convenient way to browse, order, and manage construction materials right from your mobile phone.
## Key Features:
- **Catalog Browsing:**
  
  Explore a wide range of construction and renovation materials through a user-friendly mobile interface.
  
![Alt Text](https://media.giphy.com/media/uNvpZ73FIqDMu4xk6n/giphy.gif)

- **Order Placement:**
  
  Easily and quickly place orders for necessary materials directly from the application, minimizing efforts in searching and purchasing.

![Alt Text](https://media.giphy.com/media/DP6WRFmq1N5Y4LtuaS/giphy.gif)

- **Order Management (for administrators):**
  
  Administrators have a dedicated application for efficient order management and adding new products to the inventory.

![Alt Text](https://media.giphy.com/media/gMBMQOPGOd7ScfjnqJ/giphy.gif)

## Requirements
- **iOS Platform:** iOS 15.0 
- **Swift Version:** Swift 5.5
- **Xcode Version:** Xcode 13.0
- **Dependency Manager:** Swift Package Manager (SPM)

### External Libraries:

- **SnapKit:** Used for declarative Auto Layout. [SnapKit GitHub](https://github.com/SnapKit/SnapKit)
- **Firebase:** Used for backend services, authentication, and more. [Firebase iOS Docs](https://firebase.google.com/docs/ios)
- **SDWebImage:** Used for asynchronous image loading and caching. [SDWebImage GitHub](https://github.com/SDWebImage/SDWebImage)

## Installation

1. Clone the repository: https://github.com/Anastasiia741/delivery-app.git 
2. Navigate to the project folder: cd StroybazaDeliveryApp
3. Open the project in Xcode: open StroybazaDeliveryApp.xcodeproj
4. Press `Cmd + R` to run the application.

## Usage
### Creating a New Product

**The model a new product:**

```
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
  
enum CodingKeys: String, CodingKey {
    case id, category, name, detail, description, price, image, imageUrl, quantity
}

final class Product: Codable {
    @DocumentID var documentID: String?
    var id = UUID().hashValue
    var name: String
    var category: String
    var detail: String
    var description: String
    var price: Int
    var image: String?
    var quantity: Int = 1

    private enum CodingKeys: String, CodingKey {
        case name, id, category, detail, description, price, image, quantity
    }
    
    init(id: Int, name: String, category: String, detail: String, description: String, price: Int, image: String? = nil, quantity: Int) {
        self.id = id
        self.name = name
        self.category = category
        self.detail = detail
        self.description = description
        self.price = price
        self.image = image
        self.quantity = quantity
    }
}
```
**Fetch and monitor changes of products from firebase:**

```   
//  MARK: - Fetch and monitor changes of products from firebase
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
        print("Регистрация listener удалена")
    }
 ```
**To add a new product to the Firebase Firestore and Storage:**

```
import Foundation
import FirebaseStorage
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

// MARK: - Use this method for CreateProductScreenVC
    func add(product: Product, completion: @escaping (Error?) -> Void) throws {
        try productCollection.addDocument(from: product) { error in
            completion(error)
        }
    }

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

//  MARK: - Save image in storage
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

//  MARK: - Upload imagelink in firestore
    func upload(image: UIImage?, url: String, completion: @escaping (String?, Error?) -> Void) {
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
    
```

**Manage product changes:** 

```
//  MARK: - Change product in firestore
    func update(product: Product, completion: @escaping (Error?) -> Void) {
        let productID = product.id
        productCollection.whereField("id", isEqualTo: productID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Ошибка поиска документа по ID: \(productID). Ошибка: \(error.localizedDescription)")
                completion(error)
            } else if let snapshot = querySnapshot, !snapshot.isEmpty {
                let document = snapshot.documents.first
                document?.reference.updateData([
                    "name": product.name,
                    "category": product.category,
                    "detail": product.detail,
                    "description": product.description,
                    "price": product.price,
                    "image": product.image ?? "",
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

//  MARK: - Upload image for firestore
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
```

**Delete product from firestore:** 

``` 
//  MARK: - Delete product from firestore
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
    
//  MARK: - Delete image from storage
    func deleteImage(_ imageName: String, completion: @escaping (Error?) -> Void) {
        let storageRef = storage.reference(forURL: "gs://souvenir-shop-716eb.appspot.com/products/gs:/souvenir-shop-716eb.appspot.com/productImages").child(imageName)
        storageRef.delete { error in
            completion(error)
        }
    }  
}
```
