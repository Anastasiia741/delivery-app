//  CategoryTVCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 11/9/23.

import UIKit

final class CategoryCell: UITableViewCell {
    
//  MARK: - ReuseID
    static let reuseID = ReuseId.categoryCell
//  MARK: - Event Handler
    var onCategoryTapped: ((Category)->())?
//  MARK: - Properties
    private var categories = [Category]()
    private var selectedCategory: Category?
//  MARK: - UI
    private var isFirstLaunch = true
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: Screen.width * 0.4, height: Screen.width * 0.13)
        
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: CategoryCollectionCell.reuseId)
        collection.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()

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
extension CategoryCell {
    func update(categories: [Category]) {
        self.categories = categories
        collectionView.reloadData()
    }
}

//  MARK: - Layout
private extension CategoryCell {
    
    func setupViews() {
        contentView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}

//MARK: - CollectionViewDelegate, CollectionViewDataSource
extension CategoryCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionRows.category
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.reuseId, for: indexPath) as! CategoryCollectionCell
        let category = categories[indexPath.row]
        cell.update(category)
        if isFirstLaunch && category.category == CategoryName.armature {
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.backgroundColor = .buyButton?.withAlphaComponent(0.2)
            selectedCategory = category
        } else if category == selectedCategory {
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.backgroundColor = .buyButton?.withAlphaComponent(0.2)
        } else {
            cell.contentView.backgroundColor = .systemBackground
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = self.categories[indexPath.row]
        if let previousSelectedCategory = selectedCategory {
            let previousSelectedIndex = categories.firstIndex { $0.category == previousSelectedCategory.category }
            if let index = previousSelectedIndex {
                let indexPath = IndexPath(row: index, section: SectionRows.none)
                if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionCell {
                    cell.contentView.backgroundColor = .systemBackground
                }
            }
        }
        selectedCategory = category
        collectionView.reloadData()
        isFirstLaunch = false
        onCategoryTapped?(category)
    }
}

