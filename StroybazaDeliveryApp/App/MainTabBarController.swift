//  MainTabBarController.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit

final class MainTabBarController: UITabBarController {
    
    public let menuModuleConfigurator = MenuModuleConfigurator()
    public let authModuleConfigurator = AuthModuleConfiguration()
    public let cartModuleConfigurator =  CartModuleConfigurator()
    public let profileModuleConfigurator = ProfileModuleConfigurator()
    public let adminModuleConfigurator = AdminModuleConfigurator()
    public let productEditModuleConfigurator = ProductEditModuleConfigurator()
    public let createModuleConfigurator = CreateModuleConfigurator()
    
//  MARK: - UI
    private lazy var menuVC: UINavigationController = {
        let controller = menuModuleConfigurator.configure()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.menu, tag: 0)
        controller.tabBarItem = tabBarItem
        return navigationControler
    }()
    private lazy var cartVC: UINavigationController = {
        let controller = cartModuleConfigurator.configure()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.cart, tag: 1)
        
        controller.tabBarItem = tabBarItem
        
        return navigationControler
    }()
    private lazy var profileVC: UINavigationController = {
        let controller = profileModuleConfigurator.configure()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.profile, tag: 2)
        controller.tabBarItem = tabBarItem
        return navigationControler
    }()
    private lazy var authVC: UINavigationController = {
        let controller = authModuleConfigurator.configure()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.profile, tag: 2)
        controller.tabBarItem = tabBarItem
        return navigationControler
    }()
    private lazy var adminVC: UINavigationController = {
        let controller = adminModuleConfigurator.configure()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.order, tag: 0)
        controller.tabBarItem = tabBarItem
        return navigationControler
    }()
    private lazy var productVC:  UINavigationController = {
        let controller = productEditModuleConfigurator.configure()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.product, tag: 1)
        controller.tabBarItem = tabBarItem
        return navigationControler
    }()
    private lazy var createProductVC:  UINavigationController = {
        let controller = createModuleConfigurator.configure()
        let navigationControler = UINavigationController.init(rootViewController: controller)
        let tabBarItem = UITabBarItem(title: AlertMessage.emptyMessage, image: Images.TabBar.createProduct, tag: 2)
        controller.tabBarItem = tabBarItem
        return navigationControler
    }()
    
//  MARK: - Life Сycle
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
        tabBar.tintColor = .buyButton
        tabBar.backgroundColor = .systemBackground
    }
}
