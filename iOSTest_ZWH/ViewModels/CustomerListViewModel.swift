//
//  CustomerListViewModel.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation

class CustomerListViewModel {
    var customers: [Customer] = []
    var onCustomersUpdated: (() -> ())?
    var onError: ((Error) -> ())?
    
    private var searchText: String = ""
    
    private let customerService: CustomerService
    
    init(customerService: CustomerService) {
        self.customerService = customerService
    }
    
    func fetchAllCustomers() {
        //        do {
        //            self.customers = try customerService.fetchAllCustomers()
        //            onCustomersUpdated?()
        //        } catch {
        //            onError?(error)
        //        }
        
        do {
            if searchText.isEmpty {
                self.customers = try customerService.fetchAllCustomers()
            } else {
                self.customers = try customerService.searchCustomers(by: searchText)
            }
            onCustomersUpdated?()
        } catch {
            onError?(error)
        }
    }
    
    func createCustomer(firstName: String, lastName: String, phoneNumber: String, email: String? = nil, address: String? = nil) {
        do {
            let _ = try customerService.createCustomer(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, address: address)
            fetchAllCustomers()
        } catch {
            onError?(error)
        }
    }
    
    func updateCustomer(_ customer: Customer, firstName: String, lastName: String, phoneNumber: String, email: String? = nil, address: String? = nil) {
        do {
            try customerService.updateCustomer(customer, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, address: address)
            fetchAllCustomers()
        } catch {
            onError?(error)
        }
    }
    
    func deleteCustomer(_ customer: Customer) {
        do {
            try customerService.deleteCustomer(customer)
            fetchAllCustomers()
        } catch {
            onError?(error)
        }
    }
    
    func setSearchText(_ text: String) {
        searchText = text
        fetchAllCustomers()
    }
}
