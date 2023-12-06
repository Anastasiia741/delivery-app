//  EditProductImageCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 11/10/23.

import UIKit
import FirebaseStorage
import SDWebImage

protocol EditProductDelegate: AnyObject {
    func didSelectImage(_ imageURL: String?,_ image: UIImage)
}

final class EditProductImageCell: UITableViewCell {
    
    //MARK: - ReuseId
    static let reuseId = ReuseId.editProductImageCell
    
    //MARK: - Database
    private let productDB = DBServiceProducts()
    
    //MARK: - Properties
    var selectedProduct: Product?
    private var selectedImage: UIImage?
    private var imagePicker = UIImagePickerController()
    private var selectImageHandler: (() -> Void)?
    weak var delegate: EditProductDelegate?
    
    //MARK: - UI
    var productImage = ProductImageView(style: ProductImageType.editProduct)
    
    //MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        setupAction()
        updateProductDetail()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Business Logic
extension EditProductImageCell {
    
    func updateProductDetail() {
        if let product = selectedProduct {
            if let productImage = product.image {
                let imageRef = Storage.storage().reference(forURL: productImage)
                
                imageRef.downloadURL { [weak self] url, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let url = url {
                            self?.productImage.sd_setImage(with: url, placeholderImage: UIImage())
                        }
                    }
                }
            }
        }
    }
    
}

//MARK: - UIImagePickerController
extension EditProductImageCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            productImage.image = selectedImage
            
            if let imageURL = selectedProduct?.image {
                delegate?.didSelectImage(imageURL, selectedImage)
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.present(imagePicker, animated: true, completion: nil)
        }
    }
}

//MARK: - Action
private extension EditProductImageCell {
    
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
    }
    
    func setupAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(productImageTapped))
        productImage.addGestureRecognizer(tapGesture)
        productImage.isUserInteractionEnabled = true
    }
    
    @objc func productImageTapped() {
        showAlertImage()
    }
}

//MARK: - Layout
private extension EditProductImageCell {
    
    func setupViews() {
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

//MARK: UIViewController
extension UIViewController {
    var topmostViewController: UIViewController {
        if let presented = presentedViewController {
            return presented.topmostViewController
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topmostViewController ?? self
        }
        if let tab = self as? UITabBarController {
            if let selected = tab.selectedViewController {
                return selected.topmostViewController
            } else {
                return tab.topmostViewController
            }
        }
        return self
    }
}
