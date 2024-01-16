//  AuthController.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 14/12/23.

import UIKit
import SnapKit
import FirebaseAuth

protocol AuthViewProtocol: AnyObject {
    func navigateToMenuScreen()
    func showAlert(message: String)
    func getTextFieldValues() -> (email: String?, password: String?, confirmPassword: String?)
}

final class AuthController: UIViewController, UITextFieldDelegate {
    public var presenter: AuthPresenter?
//  MARK: - UI
    private let titleLabel = MainTitleLabel(style: .auth)
    private let containerView = ContainerView()
    private let emailTextField = AuthTextField(style: .email)
    private let passwordTextField = AuthTextField(style: .password)
    private let confirmPasswordTextField = AuthTextField(style: .confirmPassword)
    private let disclaimerLabel = MainTitleLabel(style: .disclaimer)
    private let enterButton = EnterButtom(style: .authorization)
    private var registrButton = EnterButtom(style: .registration)
    private var verticalStackView = StackView(style: .verticalForAuth)
//  MARK: - Action
    private var isAuth = true
}

// MARK: - Event Handler
extension AuthController: AuthViewProtocol {
    
    func getTextFieldValues() -> (email: String?, password: String?, confirmPassword: String?) {
        let email = emailTextField.text
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        return (email, password, confirmPassword)
    }
    
    func setupActions() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view?.addGestureRecognizer(tapGestureRecognizer)
        
        let disclaimerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(disclaimerLabelTapped))
        disclaimerLabel.addGestureRecognizer(disclaimerTapGestureRecognizer)
        
        enterButton.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
        registrButton.addTarget(self, action: #selector(toggleAuthButtonTapped), for: .touchUpInside)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: AlertMessage.emptyMessage, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertMessage.okAction, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func disclaimerLabelTapped() {
        presenter?.disclaimerLabelTapped()
    }
    
    @objc func enterButtonTapped() {
        let (email, password, confirmPassword) = getTextFieldValues()
        
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            showAlert(message: AlertMessage.authMessage)
            return
        }
        
        if isAuth {
            presenter?.authenticateUser(email: email, password: password)
        } else {
            guard let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
                showAlert(message: AlertMessage.authFields)
                return
            }
            
            presenter?.registerUser(email: email, password: password, confirmPassword: confirmPassword)
        }
    }
    
    @objc func toggleAuthButtonTapped() {
        isAuth.toggle()
        setupConstraints()
        updateTitleLabel()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
    }
}


// MARK: - Navigation Logic
extension AuthController {
    
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
        UIWindow.key.rootViewController = mainTabBarController
    }
}

//  MARK: - Life Cycle
extension AuthController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActions()
        updateTitleLabel()
        updateUI()
        setupConstraints()
    }
    
    func extendedViewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        firstResponder()
    }
}

//  MARK: - Layout
private extension AuthController {
    
    func updateTitleLabel() {
        titleLabel.text = isAuth ? "\(TextMessage.authorization)" : "\(TextMessage.registration)"
    }
    
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
        verticalStackView.addArrangedSubview(registrButton)
        verticalStackView.addArrangedSubview(disclaimerLabel)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func updateUI() {
        view.backgroundColor = .systemBackground
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
                make.height.equalTo(40)
            }
            passwordTextField.snp.remakeConstraints { make in
                make.height.equalTo(40)
            }
            enterButton.snp.remakeConstraints { make in
                make.top.equalTo(passwordTextField.snp.bottom).offset(18)
                make.height.equalTo(40)
            }
            registrButton.snp.remakeConstraints { make in
                make.top.equalTo(enterButton.snp.bottom).offset(18)
                make.height.equalTo(35)
            }
            disclaimerLabel.snp.makeConstraints { make in
                make.top.equalTo(registrButton.snp.bottom).offset(8)
                make.height.equalTo(30)
            }
        } else {
            if !verticalStackView.arrangedSubviews.contains(confirmPasswordTextField) {
                verticalStackView.insertArrangedSubview(confirmPasswordTextField, at: 2)
                confirmPasswordTextField.alpha = 1
            }
            containerView.snp.updateConstraints { make in
                make.height.equalTo(330)
            }
            confirmPasswordTextField.snp.remakeConstraints { make in
                make.height.equalTo(40)
            }
            enterButton.snp.remakeConstraints { make in
                make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(18)
                make.height.equalTo(40)
            }
            registrButton.snp.remakeConstraints { make in
                make.top.equalTo(enterButton.snp.bottom).offset(18)
                make.height.equalTo(35)
            }
            disclaimerLabel.snp.makeConstraints { make in
                make.top.equalTo(registrButton.snp.bottom).offset(15)
                make.height.equalTo(30)
            }
        }
    }
}

