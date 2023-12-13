//  AdminCell.swift
//  CakeDeliveryApp
//  Created by Анастасия Набатова on 15/8/23.

import UIKit

protocol AdminCellDelegate: AnyObject {
    func orderDetailsButtonTapped(order: Order)
}

final class AdminCell: UITableViewCell {
    
//  MARK: - ReuseId
    static let reuseId = ReuseId.adminCell
//  MARK: - Properties
    private var order: Order?
    private var users: NewUser?
    weak var delegate: AdminCellDelegate?
//  MARK: - UI
    private let dateOrderLabel = MainTitleLabel(style: MainTitleType.cartTitle)
    private let orderStatusLabel = MainTitleLabel(style: MainTitleType.cartTitle)
    private let detailButton = DetailButton(style: .detail, highlightColor: .blue.withAlphaComponent(0.7), releaseColor: .blue.withAlphaComponent(0.5))
    
//  MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupActions()
        setupStyles()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//  MARK: -  Business Logic
extension AdminCell {
    func configure(_ order: Order) {
        self.order = order
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let dateString = dateFormatter.string(from: order.date)
        
        let statusText = ""
        let statusValue = order.status
        
        let attributedStatus = NSMutableAttributedString(string: statusText)
        attributedStatus.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: statusText.count))
        
        let statusAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.green,
        ]
        
        attributedStatus.append(NSAttributedString(string: statusValue, attributes: statusAttributes))
        
        dateOrderLabel.text = "Дата: \(dateString)"
        orderStatusLabel.attributedText = attributedStatus
        updateOrderStatusColor(OrderStatus(rawValue: statusValue) ?? .new)
    }
}

//  MARK: - Event Handler
private extension AdminCell {
    func setupActions() {
        detailButton.addTarget(self, action: #selector(orderDetailsButtonTapped), for: .touchUpInside)
    }
}

//  MARK: - Navigation
private extension AdminCell {
    @objc func orderDetailsButtonTapped() {
        if let order = order {
            delegate?.orderDetailsButtonTapped(order: order)
        }
    }
}

//  MARK: - Layout
private extension AdminCell {
    func setupViews() {
        contentView.addSubview(dateOrderLabel)
        contentView.addSubview(detailButton)
        contentView.addSubview(orderStatusLabel)
    }
    
    func setupStyles() {
        orderStatusLabel.textColor = .green
    }
    
    func setupConstraints() {
        
        dateOrderLabel.snp.makeConstraints { make in
            make.left.top.right.equalTo(contentView).inset(8)
        }
        
        orderStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(dateOrderLabel).inset(8)
            make.left.right.bottom.equalTo(contentView).inset(8)
        }
        
        detailButton.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).inset(8)
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
            make.height.equalTo(30)
            make.width.equalTo(80)
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
