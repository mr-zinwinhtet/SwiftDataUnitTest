//
//  InMemoryModelContainer.swift
//  iOSTest_ZWHTests
//
//  Created by Zwin on 03/09/2024.
//

import XCTest
import SwiftData
@testable import iOSTest_ZWH

class InMemoryModelContainer {
    static let shared: ModelContainer = {
        let schema = Schema([
            Customer.self,
            Car.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema)
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return container
        } catch {
            fatalError("Could not create in-memory ModelContainer: \(error)")
        }
    }()
}

class MockCarService: CarService {
    private var cars = [String: Car]()
    var shouldThrowError = false
    
    override func createCar(carNumber: String, carType: String, manufacturer: String, customerID: UUID) throws -> Car {
        if shouldThrowError {
            throw ValidationError.duplicateField("Car Number")
        }
        let car = Car(carNumber: carNumber, carType: carType, manufacturer: manufacturer, customerID: customerID)
        cars[carNumber] = car
        return car
    }
}

// Mock CustomerService
class MockCustomerService: CustomerService {
    private var customers = [UUID: Customer]()
    var shouldThrowError = false
    
    override func createCustomer(firstName: String, lastName: String, phoneNumber: String, email: String? = nil, address: String? = nil, cars: [Car] = []) throws -> Customer {
        if shouldThrowError {
            throw ValidationError.invalidFormat("Phone Number")
        }
        guard !firstName.isEmpty else { throw ValidationError.emptyField("First Name") }
        guard !lastName.isEmpty else { throw ValidationError.emptyField("Last Name") }
        guard !phoneNumber.isEmpty, phoneNumber.count == 10 else { throw ValidationError.invalidFormat("Phone Number") }
        
        let customerID = UUID()
        let customer = Customer(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, address: address)
        customers[customerID] = customer
        return customer
    }
}
