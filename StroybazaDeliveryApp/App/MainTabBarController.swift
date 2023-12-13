//  MainTabBarController.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit

final class MainTabBarController: UITabBarController {
    
//  MARK: - UI
    private let menuVC: UINavigationController = {
        let controller = MenuScreenVC()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.menu, tag: 0)
        
        controller.tabBarItem = tabBarItem
        
        return navigationControler
    }()
    private let cartVC: UINavigationController = {
        let controller = CartScreenVC()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.cart, tag: 1)
        
        controller.tabBarItem = tabBarItem
        
        return navigationControler
    }()
    private let profileVC: UINavigationController = {
        let controller = ProfileScreenVC()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.profile, tag: 2)
        
        controller.tabBarItem = tabBarItem
        
        return navigationControler
    }()
    private let authVC: UINavigationController = {
        let controller = AuthorizationScreenVC()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.profile, tag: 2)
        
        controller.tabBarItem = tabBarItem
        
        return navigationControler
    }()
    private let adminVC: UINavigationController = {
        
        let controller = AdminScreenVC()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.order, tag: 0)
        
        controller.tabBarItem = tabBarItem
        
        return navigationControler
    }()
    private let productVC:  UINavigationController = {
        
        let controller = ProductScreenVC()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.product, tag: 1)
        
        controller.tabBarItem = tabBarItem
        
        return navigationControler
    }()
    private let createProductVC:  UINavigationController = {
        
        let controller = CreateProductScreenVC()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.createProduct, tag: 2)
        
        controller.tabBarItem = tabBarItem
        
        return navigationControler
    }()
    
//  MARK: - Lifecurcle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        updateTabBarForCurrentUser()
    }
}

//  MARK: - Roles
extension MainTabBarController {
    
    func updateTabBarForCurrentUser() {
        
        if let currentUser = DBServiceAuth.shared.currentUser {
            
            if currentUser.uid == Users.userId {
                
                viewControllers = [adminVC, productVC, createProductVC]
            } else {
                viewControllers = [menuVC, cartVC, profileVC]
            }
        } else {
            viewControllers = [menuVC, cartVC, authVC]
        }
    }
}

//  MARK: - Styles
extension MainTabBarController {
    
    func setupStyles() {
        tabBar.tintColor = UIColor(named: CollorBackground.buyButton)
        tabBar.backgroundColor = .white
    }
}
