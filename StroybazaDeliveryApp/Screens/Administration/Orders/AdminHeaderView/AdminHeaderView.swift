//  AdminHeaderView.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 15/8/23.

import UIKit

final class AdminHeaderView: UITableViewHeaderFooterView {
    
//  MARK: - ReuseId
    static let reuseId = ReuseId.adminHeaderView
//  MARK: - UI
    private let allButton = StatusButton(style: .all, highlightColor: .gray.withAlphaComponent(0.7), releaseColor:  .gray.withAlphaComponent(0.5))
    private let newButton = StatusButton(style: .new, highlightColor: .gray.withAlphaComponent(0.7), releaseColor:  .gray.withAlphaComponent(0.5))
    private let processingButton = StatusButton(style: .processing, highlightColor: .gray.withAlphaComponent(0.7), releaseColor:  .gray.withAlphaComponent(0.5))
    private let shippedButton = StatusButton(style: .shipped, highlightColor: .gray.withAlphaComponent(0.7), releaseColor:  .gray.withAlphaComponent(0.5))
    private let deliveredButton = StatusButton(style: .delivered, highlightColor: .gray.withAlphaComponent(0.7), releaseColor:  .gray.withAlphaComponent(0.5))
    private let cancelledButton = StatusButton(style: .cancelled, highlightColor: .gray.withAlphaComponent(0.7), releaseColor:  .gray.withAlphaComponent(0.5))
    private let horizontalStackView = StackView(style: .horizontal)
    private let scrollView = UIScrollView()
//  MARK: - Action
    var onButtonTapped: ((OrderStatus) -> Void)?

//  MARK: - Initialization
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupAction()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//  MARK: - Navigation
private extension AdminHeaderView {
    
    @objc func allButtonTapped() {
        onButtonTapped?(.all)
    }
    
    @objc func newButtonTapped() {
        onButtonTapped?(.new)
    }
    
    @objc func processingButtonTapped() {
        onButtonTapped?(.processing)
    }
    
    @objc func shippedButtonTapped() {
        onButtonTapped?(.shipped)
    }
    
    @objc func deliveredButtonTapped() {
        onButtonTapped?(.delivered)
    }
    
    @objc func cancelledButtonTapped() {
        onButtonTapped?(.cancelled)
    }
}

//  MARK: - Layout
private extension AdminHeaderView {
    
    func setupViews() {
        contentView.addSubview(scrollView)
        let buttons: [UIButton] = [allButton, newButton, processingButton, shippedButton, deliveredButton, cancelledButton]
        buttons.forEach {horizontalStackView.addArrangedSubview($0)}
        scrollView.addSubview(horizontalStackView)
    }
    
    func setupAction() {
        allButton.addTarget(self, action: #selector(allButtonTapped), for: .touchUpInside)
        newButton.addTarget(self, action: #selector(newButtonTapped), for: .touchUpInside)
        processingButton.addTarget(self, action: #selector(processingButtonTapped), for: .touchUpInside)
        shippedButton.addTarget(self, action: #selector(shippedButtonTapped), for: .touchUpInside)
        deliveredButton.addTarget(self, action: #selector(deliveredButtonTapped), for: .touchUpInside)
        cancelledButton.addTarget(self, action: #selector(cancelledButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
    
    scrollView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
    }
    
    horizontalStackView.snp.makeConstraints { make in
        make.top.leading.equalToSuperview().offset(20)
        make.trailing.equalToSuperview().inset(20)
        make.bottom.equalToSuperview().inset(20)
    }
}
}


