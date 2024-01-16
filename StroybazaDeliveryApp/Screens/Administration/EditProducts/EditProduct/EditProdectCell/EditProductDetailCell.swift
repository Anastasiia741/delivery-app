//  EditProductDetailCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 11/10/23.

import UIKit

protocol EditProductDescriptionDelegate: AnyObject {
    func didUpdateProductInfo(_ descriptionForMain: String, _ descriptionForDetail: String)
}

final class EditProductDetailCell: UITableViewCell {
    
//  MARK: - ReuseId
    static let reuseId = ReuseId.editProductDetailCell
//  MARK: - Properties
    var selectedProduct: Product?
    weak var delegate: EditProductDescriptionDelegate?
//  MARK: - UI
    var descriptionMainTV = TitleTextView(style: .descriptionForMain)
    var descriptionDetailTV = TitleTextView(style: .descriptionForDetail)
    private let descriptionMainLabel = OrderDetailLabel(style: .descriptionProduct)
    private let descriptionDetailLabel = OrderDetailLabel(style: .productDetail)
    private var verticalStackView = StackView(style: .vertical)
    
//  MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        updateProductDetail()
        editProductDetail()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//  MARK: - Navigation
private extension EditProductDetailCell {
    func clearDescTextView() {
        descriptionMainTV.text = AlertMessage.emptyMessage
        descriptionDetailTV.text = AlertMessage.emptyMessage
    }
}

//  MARK: - Delegate
extension EditProductDetailCell: UITextViewDelegate {
    func updateProductDetail() {
        if let product = selectedProduct {
            descriptionMainTV.text = product.description
            descriptionDetailTV.text = product.detail
        }
    }
    
    private func editProductDetail() {
        descriptionMainTV.delegate = self
        descriptionDetailTV.delegate = self
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        delegate?.didUpdateProductInfo(descriptionMainTV.text, descriptionDetailTV.text)
    }
}

//  MARK: - Layout
private extension EditProductDetailCell {
    func setupViews() {
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(descriptionMainLabel)
        verticalStackView.addArrangedSubview(descriptionMainTV)
        verticalStackView.addArrangedSubview(descriptionDetailLabel)
        verticalStackView.addArrangedSubview(descriptionDetailTV)
    }
    
    func setupConstraints() {
        verticalStackView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(contentView).inset(20)
        }
    }
}
