//
//  CarDetailVC.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation
import UIKit

protocol CarDetailVCDelegate: AnyObject {
    func didUpdateCar()
}

class CarDetailVC: UIViewController {
    weak var delegate: CarDetailVCDelegate?
    var car: Car?
    var customer: Customer?
    
    private lazy var carNumberTextField: UITextField = {
        createTextField(placeholder: "Car Number", imageName: "number", isBecomeFirstResponder: true)
    }()
    
    private lazy var carTypeTextField: UITextField = {
        createTextField(placeholder: "Car Type", imageName: "car.side.fill")
    }()
    
    private lazy var manufacturerTextField: UITextField = {
        createTextField(placeholder: "Manufacturer", imageName: "gear.circle")
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 18
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var registerButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(onRegisterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var removeButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle("Remove", for: .normal)
        button.backgroundColor = UIColor.systemGray.withAlphaComponent(0.8)
        button.addTarget(self, action: #selector(onRemoveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        registerButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        removeButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
    }
    
    private let viewModel: CarDetailViewModel
    
    init(viewModel: CarDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = car == nil ? "追加" : "編集"
        setUpUI()
        populateCarDetails()
        viewModel.onCarsUpdated = {
            self.delegate?.didUpdateCar()
            self.navigationController?.popViewController(animated: true)
        }
//        viewModel.onError = { [weak self] error in
//            self?.showAlert(title: "Error", message: error.localizedDescription)
//        }
        
        viewModel.onError = { [weak self] error in
            if let validationError = error as? ValidationError {
                switch validationError {
                case .emptyField(let fieldName):
                    self?.showAlert(title: "Error", message: "\(fieldName) is required.")
                case .duplicateField(let message):
                    self?.showAlert(title: "Error", message: message)
                case .invalidFormat(let fieldName):
                    self?.showAlert(title: "Error", message: "\(fieldName) is invalid.")
                }
            } else {
                // Handle other types of errors
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func setUpUI() {
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        stackView.addArrangedSubview(carNumberTextField)
        stackView.addArrangedSubview(carTypeTextField)
        stackView.addArrangedSubview(manufacturerTextField)
        
        view.addSubview(buttonStackView)
        buttonStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        buttonStackView.addArrangedSubview(registerButton)
        if car != nil {
            buttonStackView.addArrangedSubview(removeButton)
            registerButton.setTitle("Update", for: .normal)
        }
    }
    
    private func populateCarDetails() {
        if let car = car {
            carNumberTextField.text = car.carNumber
            carTypeTextField.text = car.carType
            manufacturerTextField.text = car.manufacturer
        }
    }
    
    @objc private func onRegisterButtonTapped() {
        guard let carNumber = carNumberTextField.text, !carNumber.isEmpty else {
            showAlert(title: "Error", message: "Car Number is required")
            return
        }
        
        guard let carType = carTypeTextField.text, !carType.isEmpty else {
            showAlert(title: "Error", message: "Car Type is required")
            return
        }
        
        guard let manufacturer = manufacturerTextField.text, !manufacturer.isEmpty else {
            showAlert(title: "Error", message: "Manufacturer is required")
            return
        }
        
        if let car = car {
            viewModel.updateCar(car, carNumber: carNumber, carType: carType, manufacturer: manufacturer)
        } else {
            if let customer = customer {
                viewModel.createCar(carNumber: carNumber, carType: carType, manufacturer: manufacturer, customerID: customer.customerID)
            }
        }
    }
    
    @objc private func onRemoveButtonTapped() {
        if let car = car {
            viewModel.deleteCar(car)
            delegate?.didUpdateCar()
        }
    }
    
    
}

extension CarDetailVC: UITextFieldDelegate {
    
}
