//  BannerCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit

struct Screen {
    static let bounds = UIScreen.main.bounds
    static let width = UIScreen.main.bounds.width
}

final class BannerCell: UITableViewCell {
    
//  MARK: - ReuseId
    static let reuseId = ReuseId.bannerCell
//  MARK: - Properties
    private var banners: [Product] = []
//  MARK: - UI
    private lazy var containerView: UIView = {
        var view = UIView()
        return view
    }()
    private let titleLabel = MainTitleLabel(style: MainTitleType.menuTitle)
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: Screen.width * 0.6, height: Screen.width * 0.35)
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(BannerCollectionCell.self, forCellWithReuseIdentifier: BannerCollectionCell.reuseId)
        collection.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
//  MARK: - Action
    public var onBannerTapped: ((Product)->())?

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
extension BannerCell {
    func update(products: [Product]) {
        banners = products
        collectionView.reloadData()
    }
}

//  MARK: - Layout
private extension BannerCell {
    func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.height.equalTo(200)
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

//  MARK: - CollectionViewDelegate, CollectionViewDataSource
extension BannerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionCell.reuseId, for: indexPath) as! BannerCollectionCell
        let promoProduct = banners[indexPath.row]
        cell.update(promoProduct)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let banner = banners[indexPath.row]
        onBannerTapped?(banner)
    }
}
