//  AuthService.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 8/9/23.

import Foundation
import FirebaseAuth

final class DBServiceAuth {
   
    static let shared = DBServiceAuth()
    private let databaseProfile = DBServiceProfile.shared
    
    private let auth = Auth.auth()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    //MARK: - SignIn
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> ()) {
        
        auth.signIn(withEmail: email, password: password)  { result, error in
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - SignUp
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> ()) {
        
        auth.createUser(withEmail: email, password: password) { result, error in
            
            if let result = result {
                let newUser = NewUser(id: result.user.uid,
                                      name: "",
                                      phone: "",
                                      address: "",
                                      email: email)
                
                self.databaseProfile.setProfile(user: newUser, email: email) { resultDB in
                    
                    switch resultDB {
                    case .success(_):
                        completion(.success(result.user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        
    }
    
    //MARK: - SignOut
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
