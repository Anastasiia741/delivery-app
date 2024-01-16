//  ProfilePresenter.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 22/12/23.

import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    var orders: [Order] { get set }
    var profile: NewUser? { get set }
    var nameTF: String { get set }
    var phoneTF: String { get set}
    var addressTF: String { get set}
    
    func logout()
    func saveButtonTapped()
    func deleteAccountButtonTapped()
    
    func fetchUserProfile()
    func fetchOrderHistory()
}

final class ProfilePresenter {
    weak var view: ProfileViewProtocol?
    let cell: ProfileCellProtocol? = nil
    //  MARK: Database
    private let authService = DBServiceAuth.shared
    private let databaseService = DBServiceOrders.shared
    private let databaseProfile = DBServiceProfile.shared
    
    //  MARK: Properties
    public var orders: [Order] = [] {
        didSet {
            view?.reloadTable()
        }
    }
    public var profile: NewUser? {
        didSet {
            view?.reloadTable()
        }
    }
    var nameTF = String()
    var phoneTF = String()
    var addressTF = String()
}

extension ProfilePresenter: ProfilePresenterProtocol {
    
    func logout() {
        authService.signOut { result in
            switch result {
            case .success:
                self.view?.showAuthScreen()
            case .failure(let error):
                print("Ошибка при выходе: \(error.localizedDescription)")
            }
        }
    }
    
    func saveButtonTapped() {
        guard var updatedProfile = profile else {
            print("Профиль пользователя не инициализирован")
            return
        }
        
        updatedProfile.name = nameTF
        updatedProfile.phone = phoneTF
        updatedProfile.address = addressTF
        
        saveProfile(updatedProfile)
    }
    
    func deleteAccountButtonTapped() {
        authService.deleteAccount { result in
            switch result {
            case .success:
                print("Аккаунт успешно удален")
            case .failure(let error):
                print("Ошибка удаления аккаунта: \(error.localizedDescription)")
            }
        }
    }
}


extension ProfilePresenter {
    
    func saveProfile(_ profile: NewUser) {
        if let email = authService.currentUser?.email {
            databaseProfile.setProfile(user: profile, email: email) { [weak self] result in
                switch result {
                case .success(let updatedProfile):
                    print("Данные профиля успешно обновлены")
                    self?.profile = updatedProfile
                    self?.view?.reloadTable()
                    self?.view?.saveAlert()
                case .failure(let error):
                    print("Ошибка при сохранении данных профиля: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchUserProfile() {
        if let currentUser = authService.currentUser {
            let currentUserUID = currentUser.uid
            databaseProfile.getProfile(by: currentUserUID) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.profile = user
                    self?.view?.reloadTable()
                case .failure(let error):
                    print("Ошибка при получении данных пользователя: \(error.localizedDescription)")
                }
            }
        } else {
            view?.showAuthScreen()
        }
    }
    
    func fetchOrderHistory() {
        databaseService.fetchOrderHistory(by: authService.currentUser?.uid) { [weak self] result in
            switch result {
            case .success(let orderHistory):
                self?.orders = orderHistory
                self?.orders.sort { $0.date > $1.date }
                self?.view?.reloadTable()
                print("Полученные заказы:")
                for order in orderHistory {
                    print("Заказ ID: \(order.id) Дата: \(order.date)")
                }
            case .failure(let error):
                print("Ошибка при получении истории заказов: \(error.localizedDescription)")
            }
        }
    }
}
