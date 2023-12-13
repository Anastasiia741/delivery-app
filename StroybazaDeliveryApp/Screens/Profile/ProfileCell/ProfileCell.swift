//  ProfileCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit

protocol ProfileCellDelegate: AnyObject {
    func didSelectImage(_ image: UIImage?, _ imageURL: String)
}

final class ProfileCell: UITableViewCell {
    
//  MARK: - ReuseId
    static let reuseId = ReuseId.profileCell
//  MARK: - Properties
    private let profileDB = DBServiceProfile()
    private var profile = Profile(profile: NewUser(id: "", name: "", phone: "", address: "", email: ""))
//  MARK: - Delegate
    weak var delegate: ProfileCellDelegate?
//  MARK: - UI
    let profileImage = ProfileImageView(frame: .init())
    var nameTextField = ProfileTextField(style: .name)
    let numberTextField = ProfileTextField(style: .number)
    private let verticalStackView = StackView(style: .vertical)

//  MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//  MARK: - Business Logic
extension ProfileCell {
    func configure(with profile: NewUser) {
        nameTextField.text = profile.name
        numberTextField.text = profile.phone.isEmpty ? "+ 996" : "\(profile.phone)"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            profile.profile.name = textField.text ?? ""
        } else if textField == numberTextField {
            profile.profile.phone = textField.text ?? ""
        }
    }
}

//  MARK: - Layout
extension ProfileCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            numberTextField.becomeFirstResponder()
        }
        return true
    }
    
    func setupViews() {
        contentView.addSubview(profileImage)
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameTextField)
        verticalStackView.addArrangedSubview(numberTextField)
    
        nameTextField.delegate = self
        numberTextField.delegate = self
    }
    
    func setupConstraints() {
        profileImage.snp.makeConstraints { make in
            make.left.equalTo(contentView).inset(10)
            make.top.bottom.equalTo(contentView).inset(10)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(10)
            make.top.bottom.right.equalTo(contentView).inset(20)
        }
    }
}



