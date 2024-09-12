//
//  CustomerCell.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import UIKit

class CustomerCell: UITableViewCell {
    
    var customer: Customer? {
        didSet {
            loadData()
        }
    }
    
    var onDeleteButonTapped: (() -> ())?
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 12)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var deleteButton: CellButton = {
        let cellButton = CellButton()
        let image = UIImage(named: "close-2")!
        cellButton.setBackgroundImage(image, for: .normal)
//        cellButton.setImage(image: image)
        cellButton.imageView?.contentMode = .scaleAspectFit
        cellButton.tintColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        cellButton.addTarget(self, action: #selector(onDeleteButtonTapped_), for: .touchUpInside)
        cellButton.translatesAutoresizingMaskIntoConstraints = false
        return cellButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        
        contentView.addSubview(phoneLabel)
        phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        phoneLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        
        contentView.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: phoneLabel.leadingAnchor).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: phoneLabel.trailingAnchor).isActive = true
        
        contentView.addSubview(deleteButton)
        deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func loadData() {
        nameLabel.text = "\(customer?.firstName ?? "") \(customer?.lastName ?? "")"
        phoneLabel.text = "\(customer?.phoneNumber ?? "")"
        emailLabel.text = "\(customer?.email ?? "")"
    }
    
    @objc private func onDeleteButtonTapped_() {
        self.onDeleteButonTapped?()
    }
    
}
