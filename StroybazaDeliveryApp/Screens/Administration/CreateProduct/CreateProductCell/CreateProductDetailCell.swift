//  CreateProductDetailCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 10/10/23.

import UIKit

protocol CreateProductDescriptionDelegate: AnyObject {
    func didUpdateProductInfo(_ descriptionForMain: String, _ descriptionForDetail: String)
    
}

final class CreateProductDetailCell: UITableViewCell, UITextViewDelegate {

//  MARK: - ReuseId
    static let reuseId = ReuseId.createProductDetailCell
//  MARK: - Propertise
    weak var delegate: CreateProductDescriptionDelegate?
//  MARK: - UI
    private var verticalStackView = StackView(style: .vertical)
    private let descriptionMainLable = OrderDetailLabel(style: .descriptionForMain)
    private let descriptionDetailLable = OrderDetailLabel(style: .descriptionForDetail)
    private let descriptionMainTV = TitleTextView(style: .descriptionForMain)
    private let descriptionDetailTV = TitleTextView(style: .descriptionForDetail)
    
//  MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//  MARK: - Delegate
extension CreateProductDetailCell {
    
    func clearDescTextView() {
        descriptionMainTV.text = ""
        descriptionDetailTV.text = ""
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        delegate?.didUpdateProductInfo(descriptionMainTV.text, descriptionDetailTV.text)
    }
}

//  MARK: - Layout
private extension CreateProductDetailCell {
    
    func setupViews() {
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(descriptionMainLable)
        verticalStackView.addArrangedSubview(descriptionMainTV)
        verticalStackView.addArrangedSubview(descriptionDetailLable)
        verticalStackView.addArrangedSubview(descriptionDetailTV)
        
        descriptionMainTV.delegate = self
        descriptionDetailTV.delegate = self
    }

    func setupConstraints() {
        verticalStackView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(contentView).inset(20)
        }
    }
}
