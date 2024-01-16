//  ProfileTitileOrderCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 25/9/23.

import UIKit

final class ProfileTitileOrderCell: UITableViewCell {
    
//  MARK: - ReuseId
    static let reuseId = ReuseId.profileTitleOrderCell
//  MARK: - UI
    private let titleLabel = MainTitleLabel(style: .history)
    
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

//  MARK: - Layout
private extension ProfileTitileOrderCell {
    func setupViews() {
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(20)
            make.top.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
        }
    }
}
