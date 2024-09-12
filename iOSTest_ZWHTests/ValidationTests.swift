//
//  ValidationTests.swift
//  iOSTest_ZWHTests
//
//  Created by Zwin on 03/09/2024.
//

import XCTest
@testable import iOSTest_ZWH
import SwiftData

//import

@MainActor
final class ValidationTests: XCTestCase {
    
    private var carService: MockCarService!
    private var customerService: MockCustomerService!
    
    override func setUp() {
        super.setUp()
        let context = InMemoryModelContainer.shared.mainContext
        carService = MockCarService(context: context)
        customerService = MockCustomerService(context: context)
    }
    
    private func validateFirstName(_ firstName: String) throws {
        guard !firstName.isEmpty else { throw ValidationError.emptyField("First Name") }
    }
    
    private func validateLastName(_ lastName: String) throws {
        guard !lastName.isEmpty else { throw ValidationError.emptyField("Last Name") }
    }
    
    func testEmptyFieldValidation() {
        // Test for empty first name
        XCTAssertThrowsError(try validateFirstName("")) { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.emptyField("First Name"))
        }
        
        // Test for empty last name
        XCTAssertThrowsError(try validateLastName("")) { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.emptyField("Last Name"))
        }
    }
    
    func testCreateCarWithDuplicateCarNumber() {
        // Given: A car with a specific car number already exists
        let existingCarNumber = "5A-34342"
        let _ = try? carService.createCar(carNumber: existingCarNumber, carType: "Sedan", manufacturer: "Toyota", customerID: UUID())
        
        // When: Trying to create another car with the same car number
        carService.shouldThrowError = true
        XCTAssertThrowsError(try carService.createCar(carNumber: existingCarNumber, carType: "SUV", manufacturer: "Honda", customerID: UUID())) { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.duplicateField("Car Number"))
        }
    }
    
    func testCreateCustomerWithInvalidPhoneNumber() {
        // Given: An invalid phone number
        let invalidPhoneNumber = "1234"
        
        // When: Trying to create a customer with the invalid phone number
        XCTAssertThrowsError(try customerService.createCustomer(firstName: "John", lastName: "Doe", phoneNumber: invalidPhoneNumber)) { error in
            XCTAssertEqual(error as? ValidationError, ValidationError.invalidFormat("Phone Number"))
        }
    }
}


