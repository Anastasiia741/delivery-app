//  AuthorizationVCViewController.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit
import FirebaseAuth

final class AuthorizationScreenVC: UIViewController, UITextFieldDelegate {
    
//  MARK: - UI
    private let titleLabel = MainTitleLabel(style: .auth)
    private let containerView = ContainerView()
    private let emailTextField = AuthTextField(style: .email)
    private let passwordTextField = AuthTextField(style: .password)
    private let confirmPasswordTextField = AuthTextField(style: .confirmPassword)
    private let disclaimerLabel = MainTitleLabel(style: .disclaimer)
    private let enterButton = EnterButtom(style: .authorization)
    private var toggleAuthButton = EnterButtom(style: .registration)
    private var verticalStackView = StackView(style: .verticalForAuth)
//  MARK: - Action
    private var isAuth = true
    private var isTabViewShow = false
    private var isShowAlert = false
    
//  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActions()
        updateTitleLabel()
        updateUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstResponder()
    }
}

//  MARK: - Actions
private extension AuthorizationScreenVC {
    func setupActions() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        let disclaimerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(disclaimerLabelTapped))
        disclaimerLabel.addGestureRecognizer(disclaimerTapGestureRecognizer)
        
        enterButton.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
        toggleAuthButton.addTarget(self, action: #selector(toggleAuthButtonTapped), for: .touchUpInside)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: AlertMessage.emptyMessage, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertMessage.okAction, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func enterButtonTapped() {
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: AlertMessage.authMessage)
            return
        }
        
        if isAuth {
            DBServiceAuth.shared.signIn(email: email, password: password) { [weak self] result in
                switch result {
                case .success:
                    self?.navigateToMenuScreen()
                case .failure(let error):
                    self?.showAlert(message: "\(AlertMessage.authError) \(error.localizedDescription)")
                }
            }
        } else {
            guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
                showAlert(message: AlertMessage.authFields)
                return
            }
            
            guard password == confirmPassword else {
                showAlert(message: AlertMessage.authPassword)
                return
            }
            
            DBServiceAuth.shared.signUp(email: email, password: password) { [weak self] result in
                switch result {
                case .success:
                    self?.navigateToMenuScreen()
                case .failure(let error):
                    self?.showAlert(message: "\(AlertMessage.authErrorRegist) \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc func toggleAuthButtonTapped() {
        isAuth.toggle()
        setupConstraints()
        updateTitleLabel()
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func disclaimerLabelTapped() {
        if let url = URL(string: TextMessage.policy) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

//  MARK: - Navigation
extension AuthorizationScreenVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            if isAuth {
                textField.resignFirstResponder()
            } else {
                confirmPasswordTextField.becomeFirstResponder()
            }
        case confirmPasswordTextField:
            confirmPasswordTextField.resignFirstResponder()
        default:
            break
        }
        return true
        
    }
    
    func navigateToMenuScreen() {
        let mainTabBarController = MainTabBarController()
        mainTabBarController.modalPresentationStyle = .fullScreen
        present(mainTabBarController, animated: true, completion: nil)
    }
}

//  MARK: - Layout
private extension AuthorizationScreenVC {
    
    func firstResponder() {
        emailTextField.becomeFirstResponder()
    }
    
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(containerView)
        
        containerView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(emailTextField)
        verticalStackView.addArrangedSubview(passwordTextField)
        
        if !isAuth {
            verticalStackView.addArrangedSubview(confirmPasswordTextField)
        }
        verticalStackView.addArrangedSubview(enterButton)
        verticalStackView.addArrangedSubview(toggleAuthButton)
        verticalStackView.addArrangedSubview(disclaimerLabel)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    func updateTitleLabel() {
        titleLabel.text = isAuth ? "\(TextMessage.authorization)" : "\(TextMessage.registration)"
    }
    
    func updateUI() {
        view.backgroundColor = .white
        verticalStackView.removeArrangedSubview(confirmPasswordTextField)
        confirmPasswordTextField.removeFromSuperview()
        
        if !isAuth {
            verticalStackView.addArrangedSubview(confirmPasswordTextField)
        }
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func setupConstraints() {
        
        updateConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.left.right.equalTo(view).inset(90)
            make.height.equalTo(50)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).inset(18)
            make.left.equalTo(containerView.snp.left).inset(18)
            make.right.equalTo(containerView.snp.right).inset(18)
        }
    }
    
    func updateConstraints() {
        if isAuth {
            confirmPasswordTextField.removeFromSuperview()
            
            containerView.snp.updateConstraints { make in
                make.height.equalTo(300)
            }
            
            emailTextField.snp.remakeConstraints { make in
                make.height.equalTo(45)
            }
            
            passwordTextField.snp.remakeConstraints { make in
                make.height.equalTo(45)
            }
            
            enterButton.snp.remakeConstraints { make in
                make.top.equalTo(passwordTextField.snp.bottom).offset(18)
                make.height.equalTo(45)
            }
            
            toggleAuthButton.snp.remakeConstraints { make in
                make.top.equalTo(enterButton.snp.bottom).offset(18)
                make.height.equalTo(45)
            }
            
            disclaimerLabel.snp.makeConstraints { make in
                make.top.equalTo(toggleAuthButton.snp.bottom).offset(8)
                make.height.equalTo(50)
            }
        } else {
            if !verticalStackView.arrangedSubviews.contains(confirmPasswordTextField) {
                verticalStackView.insertArrangedSubview(confirmPasswordTextField, at: 2)
                confirmPasswordTextField.alpha = 1
            }
            
            containerView.snp.updateConstraints { make in
                make.height.equalTo(320)
            }
            
            confirmPasswordTextField.snp.remakeConstraints { make in
                make.height.equalTo(45)
            }
            
            enterButton.snp.remakeConstraints { make in
                make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(18)
                make.height.equalTo(45)
            }
            
            toggleAuthButton.snp.remakeConstraints { make in
                make.top.equalTo(enterButton.snp.bottom).offset(18)
            }
            
            disclaimerLabel.snp.makeConstraints { make in
                make.top.equalTo(toggleAuthButton.snp.bottom).offset(8)
                make.height.equalTo(50)
            }
        }
    }
}

