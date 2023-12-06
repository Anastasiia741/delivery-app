//  SkeletonView.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/12/23.

import UIKit

final class SkeletonView: UIView {
    
    //MARK: - UI
    private let nameLabelFirst = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let detailLabelFirst = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let productImageViewFirst = ProductImageView(style: ProductImageType.menuSkeleton)
    private let priceButtonFirst = PriceButton(style: PriceButtonType.colorSkeleton)
    
    //TASK: -
    private let nameLabelSecond = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let detailLabelSecond = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let productImageViewSecond  = ProductImageView(style: ProductImageType.menuSkeleton)
    private let priceButtonSecond  = PriceButton(style: PriceButtonType.colorSkeleton)
    private let nameLabelThird = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let detailLabelThird = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let productImageViewThird = ProductImageView(style: ProductImageType.menuSkeleton)
    private let priceButtonThird = PriceButton(style: PriceButtonType.colorSkeleton)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SkeletonView {
    
    private func commonInit() {
        setupViews()
        setupConstraints()
        setupGradientAnimation()
    }
    
    func startSkeletonAnimation() {
        for subview in subviews {
            applyGradient(to: subview)
        }
    }
}

//MARK: - Layout
private extension SkeletonView {
    
    private func setupGradientAnimation() {
        
        applyGradient(to: productImageViewFirst)
        applyGradient(to: nameLabelFirst)
        applyGradient(to: detailLabelFirst)
        applyGradient(to: priceButtonFirst)
        
        applyGradient(to: nameLabelSecond)
        applyGradient(to: nameLabelSecond)
        applyGradient(to: detailLabelSecond)
        applyGradient(to: priceButtonSecond)
        
        applyGradient(to: productImageViewThird)
        applyGradient(to: nameLabelThird)
        applyGradient(to: detailLabelThird)
        applyGradient(to: priceButtonThird)
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
        
        addSubview(productImageViewSecond)
        addSubview(nameLabelSecond)
        addSubview(detailLabelSecond)
        addSubview(priceButtonSecond)
        
        addSubview(productImageViewThird)
        addSubview(nameLabelThird)
        addSubview(detailLabelThird)
        addSubview(priceButtonThird)
    }
    
    func setupConstraints() {
        let spacing: CGFloat = 16
        
        productImageViewFirst.snp.makeConstraints { make in
            make.left.top.equalTo(self).offset(spacing)
            make.width.height.equalTo(100)
        }
        
        nameLabelFirst.snp.makeConstraints { make in
            make.top.equalTo(self).offset(spacing)
            make.left.equalTo(productImageViewFirst.snp.right).offset(spacing)
            make.height.equalTo(30)
            make.width.equalTo(230)
        }
        
        detailLabelFirst.snp.makeConstraints { make in
            make.top.equalTo(nameLabelFirst.snp.bottom).offset(spacing)
            make.left.equalTo(productImageViewFirst.snp.right).offset(spacing)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        
        priceButtonFirst.snp.makeConstraints { make in
            make.top.equalTo(detailLabelFirst.snp.bottom).offset(spacing)
            make.right.equalTo(self).inset(spacing)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        
        productImageViewSecond.snp.makeConstraints { make in
            make.top.equalTo(priceButtonFirst.snp.bottom).offset(spacing)
            make.left.equalTo(self).offset(spacing)
            make.width.height.equalTo(100)
        }
        
        nameLabelSecond.snp.makeConstraints { make in
            make.top.equalTo(priceButtonFirst.snp.bottom).offset(spacing)
            make.left.equalTo(productImageViewSecond.snp.right).offset(spacing)
            make.height.equalTo(30)
            make.width.equalTo(230)
        }
        
        detailLabelSecond.snp.makeConstraints { make in
            make.top.equalTo(nameLabelSecond.snp.bottom).offset(spacing)
            make.left.equalTo(productImageViewSecond.snp.right).offset(spacing)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        
        priceButtonSecond.snp.makeConstraints { make in
            make.top.equalTo(detailLabelSecond.snp.bottom).offset(spacing)
            make.right.equalTo(self).inset(spacing)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        
        productImageViewThird.snp.makeConstraints { make in
            make.top.equalTo(priceButtonSecond.snp.bottom).offset(spacing)
            make.left.equalTo(self).offset(spacing)
            make.width.height.equalTo(100)
        }
        
        nameLabelThird.snp.makeConstraints { make in
            make.top.equalTo(priceButtonSecond.snp.bottom).offset(spacing)
            make.left.equalTo(productImageViewThird.snp.right).offset(spacing)
            make.height.equalTo(30)
            make.width.equalTo(230)
        }
        
        detailLabelThird.snp.makeConstraints { make in
            make.top.equalTo(nameLabelThird.snp.bottom).offset(spacing)
            make.left.equalTo(productImageViewThird.snp.right).offset(spacing)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        
        priceButtonThird.snp.makeConstraints { make in
            make.top.equalTo(detailLabelThird.snp.bottom).offset(spacing)
            make.right.equalTo(self).inset(spacing)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
    }
    
}

extension UIColor {
    static var gradientDarkGrey: UIColor {
        return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
    }
    
    static var gradientLightGrey: UIColor {
        return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
    }
}








