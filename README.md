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
To add a new product to the Firebase Firestore:

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


