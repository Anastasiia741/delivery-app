//  AuthPresenter.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 14/12/23.

import Foundation
import UIKit

protocol AuthPresenterProtocol {
    // MARK: - User Events
    func disclaimerLabelTapped()
}

final class AuthPresenter {
    weak var view: AuthViewProtocol?
    private let database = DBServiceAuth.shared
    private var isAuth = true
}

// MARK: - Event Handler
extension AuthPresenter: AuthPresenterProtocol {
    
    func disclaimerLabelTapped() {
        if let url = URL(string: TextMessage.policy) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func authenticateUser(email: String, password: String) {
        database.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.view?.navigateToMenuScreen()
            case .failure(let error):
                print("Authentication Error: \(error), \(error.localizedDescription)")
                self?.view?.showAlert(message: "\(AlertMessage.authError) \(error.localizedDescription)")
            }
        }
    }
    
    func registerUser(email: String, password: String, confirmPassword: String) {
        guard !confirmPassword.isEmpty else {
            view?.showAlert(message: AlertMessage.authFields)
            return
        }
        
        guard password == confirmPassword else {
            view?.showAlert(message: AlertMessage.authPassword)
            return
        }
        database.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.view?.navigateToMenuScreen()
            case .failure(let error):
                print("Registration Error: \(error), \(error.localizedDescription)")
                self?.view?.showAlert(message: "\(AlertMessage.authErrorRegist) \(error.localizedDescription)")
            }
        }
    }
}







