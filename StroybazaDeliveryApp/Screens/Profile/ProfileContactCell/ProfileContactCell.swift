//  ProfileContactCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit

protocol ProfileContactProtocol: AnyObject {
    func didUpdateContactInfo(_ address: String?)
}

final class ProfileContactCell: UITableViewCell, UITextFieldDelegate {
    
//  MARK: - ReuseId
    static let reuseId = ReuseId.profileContactCell
//  MARK: - Propertice
    var profile = Profile(profile: NewUser(id: "", name: "", phone: "", address: "", email: ""))
//  MARK: - UI
    private let emailLabel = MainTitleLabel(style: .emailTitle)
    private let titleLabel = MainTitleLabel(style: .contact)
    let emailTextField = MainTitleLabel(style: .email)
    let addressTextField = ProfileTextField(style: .address)
    private let verticalStackView = StackView(style: .vertical)
    weak var delegate: ProfileContactProtocol?

    
//  MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        setupViews()
        setupAction()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//  MARK: -  Business Logic
extension ProfileContactCell {
    
    func setupAction() {
        addressTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func configure(with profile: NewUser, email: String) {
        emailTextField.text = email
        addressTextField.text = profile.address
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let address = addressTextField.text {
            delegate?.didUpdateContactInfo(address)
        }
    }
}

//  MARK: - layout
private extension ProfileContactCell {
    
    func setupViews() {
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(emailLabel)
        verticalStackView.addArrangedSubview(emailTextField)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(addressTextField)
        
        addressTextField.delegate = self
    }
    
    func setupConstraints() {
        verticalStackView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(20)
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(30)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
    }
}

