//  CreateProdectCellTableViewCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 10/10/23.

import UIKit
import SnapKit

protocol CreateProductDelegate: AnyObject {
    func didSelectImage(_ image: UIImage?, _ imageURL: String)
}

final class CreateProductImageCell: UITableViewCell, UINavigationControllerDelegate {
    
//  MARK: - ReuseId
    static let reuseId = ReuseId.createProductImageCell
//  MARK: - Database
    private let productDB = DBServiceProducts()
//  MARK: - Delegate
    private var selectedImage: UIImage?
    private var imagePicker = UIImagePickerController()
    private var selectImageHandler: (() -> Void)?
    weak var delegate: CreateProductDelegate?
//  MARK: - UI
    private let productImage = ProductImageView(style: .editProduct)
    
//  MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ImagePicker
extension CreateProductImageCell: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            productImage.image = selectedImage
            let imageIdentifier = UUID().uuidString
            delegate?.didSelectImage(selectedImage, imageIdentifier)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.present(imagePicker, animated: true, completion: nil)
        }
    }
}

//MARK: - Actions
private extension CreateProductImageCell {
    
    func showAlertImage() {
        
        let alertController = UIAlertController(title: AlertMessage.imageTitle, message: nil, preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: AlertMessage.galeryAction, style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: AlertMessage.photoAction, style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .camera)
        }
        
        let cancelAction = UIAlertAction(title: AlertMessage.cancelAction, style: .cancel, handler: nil)
        
        alertController.addAction(galleryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        if let topViewController = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController?.topmostViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
        
        selectImageFromGallery()
    }
    
    func selectImageFromGallery() {
        if let selectedImage = selectedImage {
            let fileName = UUID().uuidString + ".jpg"
            if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                productDB.save(imageData: imageData, nameImg: fileName) { [weak self] imageLink in
                    if let imageLink = imageLink {
                        self?.delegate?.didSelectImage(selectedImage, imageLink)
                    }
                }
            }
        }
    }
    
    func setupAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(productImageTapped))
        productImage.isUserInteractionEnabled = true
        productImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func productImageTapped() {
        showAlertImage()
    }
}


//MARK: - Bussines Logic
 extension CreateProductImageCell {
    
    @objc func imageDidChange() {
        productImage.image = UIImage(named: Images.Picture.productImage)
    }
}

//MARK: - Layout
private extension CreateProductImageCell {
    
    func setupViews() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(productImage)
    }
    
    func setupConstraints() {
        productImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(20)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
}
