//
//  CustomerDetailViewModel.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation

class CustomerDetailViewModel {
    var cars: [Car] = []
    var onCarsFetched: (() -> ())?
    var onUpdated: (() -> ())?
    var onError: ((Error) -> ())?
    
    private let customerService: CustomerService
    private let carService: CarService
    private let customerID: UUID?
    
    init(customerService: CustomerService, carService: CarService, customerID: UUID? = nil) {
        self.customerService = customerService
        self.carService = carService
        self.customerID = customerID
        if let customerID = customerID {
            fetchCars(for: customerID)
        }
    }
    
    func fetchCars(for customerID: UUID) {
        do {
            self.cars = try carService.fetchCars(byCustomerID: customerID)
            onCarsFetched?()
        } catch {
            onError?(error)
        }
    }
    
    func createCustomer(firstName: String, lastName: String, phoneNumber: String, email: String?, address: String?) {
        do {
            _ = try customerService.createCustomer(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, address: address)
            onUpdated?()
        } catch {
            onError?(error)
        }
    }
    
    func updateCustomer(_ customer: Customer, firstName: String?, lastName: String?, phoneNumber: String?, email: String?, address: String?) {
        do {
            try customerService.updateCustomer(customer, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, address: address)
            onUpdated?()
        } catch {
            onError?(error)
        }
    }
    
    func deleteCustomer(_ customer: Customer) {
        do {
            try customerService.deleteCustomer(customer)
            onUpdated?()
        } catch {
            onError?(error)
        }
    }
}
