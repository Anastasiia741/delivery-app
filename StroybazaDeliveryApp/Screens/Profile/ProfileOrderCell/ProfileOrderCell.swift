//  ProfileOrderCell.swift
//  StroybazaDeliveryApp
//  Created by Анастасия Набатова on 2/8/23.

import UIKit
import SnapKit

final class ProfileOrderCell: UITableViewCell {
    
    //MARK: - ReuseId
    static let reuseId = ReuseId.profileOrderCell
   
    //MARK: - Propertice
    let order = Order(id: "", userID: "", positions: [], date: Date(), status: "", promocode: "")
    
    //MARK: - UI
    let orderDateLabel = MainTitleLabel(style: .orderHistory)
    let orderAmountLabel = MainTitleLabel(style: .orderAmount)
    let orderStatusLabel = MainTitleLabel(style: .orderStatus)
    let horizontalStack = StackView(style: .horizontal)
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Business logic
extension ProfileOrderCell {
    
    func configure(with orderHistory: Order) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: orderHistory.date)
        orderDateLabel.text = "Дата заказа: \(dateString)"
        orderAmountLabel.text = "\(orderHistory.cost) сом"
        orderStatusLabel.text = orderHistory.status
        
        updateOrderStatusColor(OrderStatus(rawValue: orderHistory.status) ?? .new)
    }
}

//MARK: - Layout
private extension ProfileOrderCell {
    
    func setupViews() {
        contentView.addSubview(horizontalStack)
        horizontalStack.addSubview(orderDateLabel)
        horizontalStack.addSubview(orderAmountLabel)
        horizontalStack.addSubview(orderStatusLabel)
    }
    
    func setupConstraints() {
       
        horizontalStack.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        
        orderDateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        orderAmountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-20)
        }
        
        orderStatusLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(20)
        }
        
        
    }
    
    func updateOrderStatusColor(_ status: OrderStatus) {
        switch status {
        case .new:
            orderStatusLabel.textColor = UIColor(named: StatusColor.new)
        case .processing:
            orderStatusLabel.textColor = UIColor(named: StatusColor.inProgress)
        case .shipped:
            orderStatusLabel.textColor = UIColor(named: StatusColor.sended)
        case .delivered:
            orderStatusLabel.textColor = UIColor(named: StatusColor.delivered)
        case .cancelled:
            orderStatusLabel.textColor = UIColor(named: StatusColor.cancelled)
        default:
            orderStatusLabel.textColor = .black
        }
    }
}
