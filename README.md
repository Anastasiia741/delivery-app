# Stroybaza Delivery App 🛠️🏡📲
This mobile application provides a convenient way to browse, order, and manage construction materials right from your mobile phone.

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

## MVP Architecture

This project adopts the Model-View-Presenter (MVP) architecture to application logic.

- **Model:**
The Model represents the data and business logic of the application. It is responsible for handling data storage, retrieval, and manipulation. In an MVP architecture, the Model notifies the Presenter of any changes in the data.
- **View:**
The View is responsible for displaying the user interface and presenting data to the user. It communicates with the Presenter to request data and updates. The View is passive and does not contain business logic. It observes changes in the Model and updates the UI accordingly.
- **Presenter:**
The Presenter acts as an intermediary between the Model and the View. It receives user input from the View, processes it (if needed), and updates the Model accordingly. The Presenter also receives updates from the Model and instructs the View to reflect these changes. It ensures a separation of concerns by handling the application's logic.



