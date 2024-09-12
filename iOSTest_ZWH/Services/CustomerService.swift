//
//  CustomerService.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation
import SwiftData


class CustomerService {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func createCustomer(firstName: String, lastName: String, phoneNumber: String, email: String? = nil, address: String? = nil, cars: [Car] = []) throws -> Customer {
        guard !firstName.isEmpty else { throw ValidationError.emptyField("First Name") }
        guard !lastName.isEmpty else { throw ValidationError.emptyField("Last Name") }
        guard !phoneNumber.isEmpty else { throw ValidationError.emptyField("Phone Number") }
        guard phoneNumber.isPhoneNumber else { throw ValidationError.invalidFormat("Phone Number") }
        if let email = email, !email.isEmpty, !email.isEmail {
            throw ValidationError.invalidFormat("Email")
        }
        
        let customer = Customer(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, address: address)
        context.insert(customer)
        try saveContext()
        return customer
    }
    
    func fetchAllCustomers() throws -> [Customer] {
        do {
            return try context.fetch(FetchDescriptor<Customer>())
        } catch {
            throw CoreDataError.fetchError(error.localizedDescription)
        }
    }
    
    func fetchCustomer(byID customerID: UUID) throws -> Customer? {
        let predicate = #Predicate<Customer> { $0.customerID == customerID }
        let fetchDescriptor = FetchDescriptor<Customer>(predicate: predicate)
        do {
            return try context.fetch(fetchDescriptor).first
        } catch {
            throw CoreDataError.fetchError(error.localizedDescription)
        }
    }
    
    func updateCustomer(_ customer: Customer, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, email: String? = nil, address: String? = nil) throws {
        if let firstName = firstName, !firstName.isEmpty {
            customer.firstName = firstName
        } else if firstName != nil {
            throw ValidationError.emptyField("First Name")
        }
        if let lastName = lastName, !lastName.isEmpty {
            customer.lastName = lastName
        } else if lastName != nil {
            throw ValidationError.emptyField("Last Name")
        }
        if let phoneNumber = phoneNumber, !phoneNumber.isEmpty {
            guard phoneNumber.isPhoneNumber else { throw ValidationError.invalidFormat("Phone Number") }
            customer.phoneNumber = phoneNumber
        }
        if let email = email, !email.isEmpty {
            guard email.isEmail else { throw ValidationError.invalidFormat("Email") }
            customer.email = email
        }
        if let address = address {
            customer.address = address
        }
        try saveContext()
    }
    
    func deleteCustomer(_ customer: Customer) throws {
        context.delete(customer)
        try saveContext()
    }
    
    func searchCustomers(by keyword: String) throws -> [Customer] {
        let predicate = #Predicate<Customer> {
            $0.firstName.contains(keyword) || $0.lastName.contains(keyword) || $0.phoneNumber.contains(keyword)
        }
        let fetchDescriptor = FetchDescriptor<Customer>(predicate: predicate)
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            throw CoreDataError.fetchError(error.localizedDescription)
        }
    }
    
    func deleteAllCustomers() throws {
        let customers = try fetchAllCustomers()
        for customer in customers {
            context.delete(customer)
        }
        try saveContext()
    }
    
    private func saveContext() throws {
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveError(error.localizedDescription)
        }
    }
}

enum ValidationError: LocalizedError, Equatable {
    case emptyField(String)
    case duplicateField(String)
    case invalidFormat(String)
    
    var errorDescription: String? {
        switch self {
        case .emptyField(let fieldName):
            return "\(fieldName) is required."
        case .duplicateField(let message):
            return message
        case .invalidFormat(let fieldName):
            return "\(fieldName) is invalid format."
        }
    }
}

enum CoreDataError: Error {
    case fetchError(String)
    case saveError(String)
}
