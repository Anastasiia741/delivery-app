//  SkeletonView.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 2/12/23.

import UIKit

class SkeletonView: UIView {
    
    //MARK: - UI
    private let nameLabelFirst = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let detailLabelFirst = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let productImageViewFirst = ProductImageView(style: ProductImageType.menuSkeleton)
    private let priceButtonFirst = PriceButton(style: PriceButtonType.colorSkeleton)
    
    private let nameLabelSecond = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let detailLabelSecond = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let productImageViewSecond  = ProductImageView(style: ProductImageType.menuSkeleton)
    private let priceButtonSecond  = PriceButton(style: PriceButtonType.colorSkeleton)
    private let nameLabelThird = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let detailLabelThird = MainTitleLabel(style: MainTitleType.productSkeleton)
    private let productImageViewThird = ProductImageView(style: ProductImageType.menuSkeleton)
    private let priceButtonThird = PriceButton(style: PriceButtonType.colorSkeleton)
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//        setupConstraints()
//        setupGradientAnimation()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        setupGradientAnimation()
//
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension SkeletonView {
    
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
    }
    
    
    func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {
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
        group.duration = anim2.beginTime + anim2.duration
        group.isRemovedOnCompletion = false
        
        if let previousGroup = previousGroup {
            group.beginTime = previousGroup.beginTime + 0.33
            
        }
        
        return group
    }
    
    
    private func applyGradient(to view: UIView) {
        let gradient = CAGradientLayer()

        gradient.cornerRadius = 8
        gradient.frame = view.bounds
        let animationGroup = makeAnimationGroup()
        view.layer.cornerRadius = 8
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
            make.left.top.equalTo(self).offset(16)
            make.width.height.equalTo(100)
        }
        
        nameLabelFirst.snp.makeConstraints { make in
            make.top.equalTo(self).offset(16)
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
            make.right.equalTo(self).inset(16)
            make.height.equalTo(35)
            make.width.equalTo(130)
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








