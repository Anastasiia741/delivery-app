//  SkeletonCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 6/12/23.

import UIKit

class SkeletonCell: UITableViewCell {
    
    static let reuseId = "CustomTableViewCell"
    
    private let nameLabelFirst = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let detailLabelFirst = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let productImageViewFirst = ProductImageView(style: ProductImageType.menuSkeleton)
    private let priceButtonFirst = PriceButton(style: PriceButtonType.colorSkeleton)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        setupGradientAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SkeletonCell {
    
    func startSkeletonAnimation() {
        for subview in subviews {
            applyGradient(to: subview)
        }
    }
}

//MARK: - Layout
private extension SkeletonCell {
    
    private func setupGradientAnimation() {
        applyGradient(to: productImageViewFirst)
        applyGradient(to: nameLabelFirst)
        applyGradient(to: detailLabelFirst)
        applyGradient(to: priceButtonFirst)
    }
    
    private func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {
        let animDuration: CFTimeInterval = 1.5
        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor.gradientLightGrey.cgColor
        anim1.toValue = UIColor.gradientDarkGrey.cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0
        
        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor.gradientDarkGrey.cgColor
        anim2.toValue = UIColor.gradientLightGrey.cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + anim1.duration
        
        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude
        group.duration = anim2.beginTime + anim2.duration + 0.33
        group.isRemovedOnCompletion = false
        
        if let previousGroup = previousGroup {
            group.beginTime = previousGroup.beginTime + 0.33
        }
        return group
    }
    
    private func applyGradient(to view: UIView) {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 8
        gradient.frame = view.bounds
        gradient.colors = [UIColor.gradientLightGrey.cgColor, UIColor.gradientDarkGrey.cgColor]
        gradient.locations = [0.0, 1.0]
        
        let animationGroup = makeAnimationGroup()
        animationGroup.beginTime = 0.0
        view.layer.cornerRadius = 8
        
        view.layer.masksToBounds = true
        view.layer.addSublayer(gradient)
        
        gradient.add(animationGroup, forKey: "backgroundColor")
    }
    
    func setupViews() {
        backgroundColor = .white
        addSubview(productImageViewFirst)
        addSubview(nameLabelFirst)
        addSubview(detailLabelFirst)
        addSubview(priceButtonFirst)
        
    }
    
    func setupConstraints() {
        
        productImageViewFirst.snp.makeConstraints { make in
            make.left.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(100)
        }
        
        nameLabelFirst.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.left.equalTo(productImageViewFirst.snp.right).offset(16)
            make.height.equalTo(30)
            make.width.equalTo(230)
        }
        
        detailLabelFirst.snp.makeConstraints { make in
            make.top.equalTo(nameLabelFirst.snp.bottom).offset(16)
            make.left.equalTo(productImageViewFirst.snp.right).offset(16)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        
        priceButtonFirst.snp.makeConstraints { make in
            make.top.equalTo(detailLabelFirst.snp.bottom).offset(16)
            make.right.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(35)
            make.width.equalTo(130)
        }
    }
}


