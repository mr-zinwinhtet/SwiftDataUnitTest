//
//  CustomerListVC.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation
import UIKit

class CustomerListVC: UIViewController {
    
    private let viewModel: CustomerListViewModel
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search customers"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomerCell.self, forCellReuseIdentifier: "customerCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "お客様"
        view.backgroundColor = .white
        setUpUI()
        setupNavigationBar()
        viewModel.fetchAllCustomers()
        viewModel.onCustomersUpdated = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setUpUI() {
        view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCustomer))
    }
    
    @objc private func addCustomer() {
        guard let customerService = DependencyContainer.shared.resolve(type: CustomerService.self) else {
            showAlert(title: "Error!", message: "CustomerService can't be resolved.")
            return
        }
        guard let carService = DependencyContainer.shared.resolve(type: CarService.self) else {
            showAlert(title: "Error!", message: "CarService can't be resolved.")
            return
        }
        let vc = CustomerDetailVC(viewModel: CustomerDetailViewModel(customerService: customerService, carService: carService))
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: false)
    }
    
    init(viewModel: CustomerListViewModel, customerService: CustomerService) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// TableView
extension CustomerListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.customers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerCell", for: indexPath) as! CustomerCell
        let customer = viewModel.customers[indexPath.row]
        cell.customer = customer
        cell.onDeleteButonTapped = {
            self.viewModel.deleteCustomer(customer)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = viewModel.customers[indexPath.row]
        guard let customerService = DependencyContainer.shared.resolve(type: CustomerService.self) else {
            showAlert(title: "Error!", message: "CarService can't be resolved.")
            return
        }
        guard let carService = DependencyContainer.shared.resolve(type: CarService.self) else {
            showAlert(title: "Error!", message: "CustomerService can't be resolved.")
            return
        }
        let vc = CustomerDetailVC(viewModel: CustomerDetailViewModel(customerService: customerService, carService: carService, customerID: customer.customerID))
        vc.customer = customer
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

// delegating with Detail View
extension CustomerListVC: CustomerDetailVCDelegate {
    func didSaveCustomer() {
        viewModel.fetchAllCustomers()
    }
}

extension CustomerListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.setSearchText(searchText)
        viewModel.fetchAllCustomers()
    }
}
