//
//  CarCell.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation
import UIKit

class CarCell: UITableViewCell {
    
    var car: Car? {
        didSet {
            loadData()
        }
    }
    
    var allContentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white // Set background color to white (or desired color)
        view.layer.cornerRadius = 10 // Set corner radius for rounded corners
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var manufactureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
        addSubview(allContentsView)
        allContentsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        allContentsView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        allContentsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        allContentsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        allContentsView.addSubview(carImageView)
        carImageView.leadingAnchor.constraint(equalTo: allContentsView.leadingAnchor, constant: 12).isActive = true
        carImageView.centerYAnchor.constraint(equalTo: allContentsView.centerYAnchor).isActive = true
        carImageView.topAnchor.constraint(equalTo: allContentsView.topAnchor, constant: 12).isActive = true
        carImageView.bottomAnchor.constraint(equalTo: allContentsView.bottomAnchor, constant: -12).isActive = true
        carImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        carImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        allContentsView.addSubview(numberLabel)
        numberLabel.leadingAnchor.constraint(equalTo: carImageView.trailingAnchor, constant: 32).isActive = true
        numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        numberLabel.topAnchor.constraint(equalTo: allContentsView.topAnchor, constant: 8).isActive = true
        
        allContentsView.addSubview(typeLabel)
        typeLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor).isActive = true
        typeLabel.trailingAnchor.constraint(equalTo: numberLabel.trailingAnchor).isActive = true
        typeLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 8).isActive = true
        
        allContentsView.addSubview(manufactureLabel)
        manufactureLabel.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor).isActive = true
        manufactureLabel.trailingAnchor.constraint(equalTo: typeLabel.trailingAnchor).isActive = true
        manufactureLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func loadData() {
        numberLabel.text = car?.carNumber
        typeLabel.text = car?.carType
        manufactureLabel.text = car?.manufacturer
        displayRandomImage()
    }
    
    private func displayRandomImage() {
        let randomImageIndex = Int.random(in: 1...11)
        let imageName = "\(randomImageIndex)"
        carImageView.image = UIImage(named: imageName)
    }
    
}
