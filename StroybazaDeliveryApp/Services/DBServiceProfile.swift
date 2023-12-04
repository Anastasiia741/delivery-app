//  DBServiceUser.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 3/10/23.

import Foundation
import FirebaseFirestore
import FirebaseStorage

final class DBServiceProfile {
    
    static let shared = DBServiceProfile()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    //MARK: - Update profile info
    func setProfile(user: NewUser, email: String, completion: @escaping (Result<NewUser, Error>) -> ()) {
        
        var updatedUser = user
        updatedUser.email = email
        print(updatedUser)

        print(user)
        usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    
    //MARK: - Get profile info
    func getProfile(by userId: String? = nil, completion: @escaping (Result<NewUser, Error>) -> ()) {
           
           let documentIdToFetch = userId != nil ? userId! : DBServiceAuth.shared.currentUser!.uid
           
           usersRef.document(documentIdToFetch).getDocument { docSnapshot, error  in
               if let error = error {
                   print("Ошибка при получении профиля пользователя: \(error.localizedDescription)")
                   completion(.failure(error))
                   return
               }
               
               guard let snap = docSnapshot, snap.exists else {
                   print("Документ профиля пользователя не найден")
                   completion(.failure(NSError(domain: "", code: 404, userInfo: nil)))
                   return
               }
               
               if let data = snap.data(),
                  let userName = data["name"] as? String,
                  let id = data["id"] as? String,
                  let phone = data["phone"] as? String,
                  let address = data["address"] as? String,
                  let email = data["email"] as? String {
                   let user = NewUser(id: id, name: userName, phone: phone, address: address, email: email)
                   completion(.success(user))
               } else {
                   print("User profile document has incorrect structure")
                   completion(.failure(NSError(domain: "", code: 500, userInfo: nil)))
               }
           }
       }
    
    //MARK: - Save profile image
    func save(imageData: Data, nameImg: String, completion: @escaping (_ imageLink: String?) -> Void) {
        
        let storageRef = storage.reference(forURL: "gs://souvenir-shop-716eb.appspot.com/profileImages").child(nameImg)
        
        _ = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            
            if let error = error {
                print("Ошибка загрузки:", error)
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
    
}
