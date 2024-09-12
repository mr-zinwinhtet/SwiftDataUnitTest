//
//  CustomerDetailVC.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import UIKit

protocol CustomerDetailVCDelegate: AnyObject {
    func didSaveCustomer()
}

class CustomerDetailVC: UIViewController {
    
    weak var delegate: CustomerDetailVCDelegate?
    var customer: Customer?
    var viewModel: CustomerDetailViewModel
    
    init(viewModel: CustomerDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var firstNameTextField: UITextField = {
        createTextField(placeholder: "First Name", imageName: "person", returnKeyType: .next, isBecomeFirstResponder: true)
    }()
    
    private lazy var lastNameTextField: UITextField = {
        createTextField(placeholder: "Last Name", imageName: "person", returnKeyType: .next)
    }()
    
    private lazy var phoneNumberTextField: UITextField = {
        createTextField(placeholder: "Phone Number", imageName: "candybarphone", keyboardType: .numberPad, returnKeyType: .next)
    }()
    
    private lazy var emailTextField: UITextField = {
        createTextField(placeholder: "Email", imageName: "envelope.fill", keyboardType: .emailAddress, returnKeyType: .done)
    }()
    
    private lazy var addressTextField: UITextField = {
        createTextField(placeholder: "Address", imageName: "location.fill", returnKeyType: .done)
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var saveButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle("Save", for: .normal)
        button.setImage(UIImage(systemName: "arrow.up.doc"), for: .normal)
        button.tintColor = .white
        button.semanticContentAttribute = .forceLeftToRight
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var carTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CarCell.self, forCellReuseIdentifier: "carCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = customer == nil ? "追加" : "編集"
        
        setUpUI()
        populateCustomerDetails()
        if let customer = customer {
            setupNavigationBar()
            viewModel.fetchCars(for: customer.customerID)
        }
        
        viewModel.onUpdated = {
            self.delegate?.didSaveCustomer()
            self.navigationController?.popViewController(animated: true)
        }
        
        viewModel.onCarsFetched = {
            DispatchQueue.main.async {
                self.carTableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        saveButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
    }
    
    private func setUpUI() {
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        stackView.addArrangedSubview(firstNameTextField)
        stackView.addArrangedSubview(lastNameTextField)
        stackView.addArrangedSubview(phoneNumberTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(addressTextField)
        
        view.addSubview(saveButton)
        saveButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(carTableView)
        carTableView.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 30).isActive = true
        carTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22).isActive = true
        carTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22).isActive = true
        carTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }
    
    private func populateCustomerDetails() {
        if let customer = customer {
            firstNameTextField.text = customer.firstName
            lastNameTextField.text = customer.lastName
            phoneNumberTextField.text = customer.phoneNumber
            emailTextField.text = customer.email
            addressTextField.text = customer.address
        }
    }
    
    private func setupNavigationBar() {
        
        let barButtonItem = UIBarButtonItem(title: "Add Car", style: .plain, target: self, action: #selector(addCarButtonTapped))
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 16)!]
        barButtonItem.setTitleTextAttributes(fontAttributes, for: .normal)
        
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func saveButtonTapped() {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            showAlert(title: "Error!", message: "First Name is required")
            return
        }
        
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            showAlert(title: "Error!", message: "Last Name is required")
            return
        }
        
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty, phoneNumber.isPhoneNumber else {
            showAlert(title: "Error!", message: "Valid Phone Number is required")
            return
        }
        
        let email = emailTextField.text?.isEmpty == false ? emailTextField.text : nil
        let address = addressTextField.text?.isEmpty == false ? addressTextField.text : nil
        
        if let email = email, !email.isEmail {
            showAlert(title: "Error!", message: "Valid Email Address is required")
            return
        }
        
        if let customer = customer {
            viewModel.updateCustomer(customer, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, address: address)
        } else {
            viewModel.createCustomer(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, address: address)
        }
        
        delegate?.didSaveCustomer()
    }
    
    @objc func addCarButtonTapped() {
        guard let carService: CarService = DependencyContainer.shared.resolve(type: CarService.self) else {
            fatalError("CarService can't be resolved.")
        }
        let vc = CarDetailVC(viewModel: CarDetailViewModel(carService: carService))
        vc.customer = self.customer
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CustomerDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carCell", for: indexPath) as! CarCell
        let car = viewModel.cars[indexPath.row]
        cell.car = car
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCar = viewModel.cars[indexPath.row]
        guard let carService: CarService = DependencyContainer.shared.resolve(type: CarService.self) else {
            showAlert(title: "Error!", message: "CarService can't be resolved.")
            return
        }
        let carDetailViewModel = CarDetailViewModel(carService: carService)
        let carDetailVC = CarDetailVC(viewModel: carDetailViewModel)
        carDetailVC.car = selectedCar
        carDetailVC.customer = self.customer
        carDetailVC.delegate = self
        navigationController?.pushViewController(carDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
}

extension CustomerDetailVC: CarDetailVCDelegate {
    func didUpdateCar() {
        if let customer = customer {
            viewModel.fetchCars(for: customer.customerID)
        }
    }
}

extension CustomerDetailVC: UITextFieldDelegate {
    
}


