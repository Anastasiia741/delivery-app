//  PromoCellCollectionViewCell.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit

final class PromoCell: UITableViewCell {
    
    var onPromoTapped: ((Product)->())?
    static let reuseId = ReuseId.promoCell
    private var products: [Product] = []
    
    private let titleLabel = MainTitleLabel(style: .cartAddTitle)
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: Screen.width * 0.6, height: Screen.width * 0.30)
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(PromoCollectionCell.self, forCellWithReuseIdentifier: PromoCollectionCell.reuseId)
        collection.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    private let containerView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(named: CollorBackground.backgroundPromo)
        view.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Public
extension PromoCell {
    
    func update(products: [Product]) {
        self.products = products
        collectionView.reloadData()
    }
}

//MARK: - Layout
private extension PromoCell {
    
    func setupViews() {
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerView).inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.right.left.bottom.equalTo(containerView)
        }
    }
}

extension PromoCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoCollectionCell.reuseId, for: indexPath) as! PromoCollectionCell
        
        let promoProduct = products[indexPath.row]
        cell.update(promoProduct)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let promoProduct = products[indexPath.row]
        
        onPromoTapped?(promoProduct)
        print("Tap")
    }
}

