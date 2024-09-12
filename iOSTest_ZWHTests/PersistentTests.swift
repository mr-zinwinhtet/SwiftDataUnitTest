//
//  PersistentTests.swift
//  iOSTest_ZWHTests
//
//  Created by Zwin on 03/09/2024.
//

import Foundation
import XCTest

@MainActor
final class PersistentTests: XCTestCase {

    private var carService: CarService!
    private var customerService: CustomerService!

    override func setUp() {
        super.setUp()
        let context = InMemoryModelContainer.shared.mainContext
        carService = CarService(context: context)
        customerService = CustomerService(context: context)
    }

    func testCreateCar() throws {
        let customerID = UUID()
        let car = try carService.createCar(carNumber: "1A-7788", carType: "Jeep", manufacturer: "Shan Star", customerID: customerID)
        XCTAssertEqual(car.carNumber, "1A-7788")
        XCTAssertEqual(car.carType, "Jeep")
        XCTAssertEqual(car.manufacturer, "Shan Star")
    }

    func testFetchAllCars() throws {
        // clear all cars first (not to be failed)
        try carService.deleteAllCars()
        let customerID = UUID()
        _ = try carService.createCar(carNumber: "3I-9837", carType: "Fit", manufacturer: "Honda", customerID: customerID)
        let cars = try carService.fetchAllCars()
        XCTAssertEqual(cars.count, 1)
    }

    func testFetchCarByCarNumber() throws {
        let customerID = UUID()
        _ = try carService.createCar(carNumber: "5B-8877", carType: "Caldina", manufacturer: "Toyota", customerID: customerID)
        let car = try carService.fetchCar(byCarNumber: "5B-8877")
        XCTAssertNotNil(car)
        XCTAssertEqual(car?.carNumber, "5B-8877")
    }

    func testUpdateCar() throws {
        let customerID = UUID()
        let car = try carService.createCar(carNumber: "3A-1232", carType: "Saloon", manufacturer: "Toyota", customerID: customerID)
        print("OriginalCar: \(car.carNumber) \(car.carType) \(car.manufacturer)")
        try carService.updateCar(car, carNumber: "5I-9191", carType: "SUV", manufacturer: "Honda")
        let updatedCar = try carService.fetchCar(byCarNumber: "5I-9191")
        if let updatedCar = updatedCar {
            print("UpdatedCar: \(updatedCar.carNumber) \(updatedCar.carType) \(updatedCar.manufacturer)")
        } else {
            print("UpdatedCar: is nil")
        }
        
        XCTAssertNotNil(updatedCar)
        XCTAssertEqual(updatedCar?.carNumber, "5I-9191")
    }

    func testDeleteCar() throws {
        let customerID = UUID()
        let car = try carService.createCar(carNumber: "DD-12345", carType: "Sedan", manufacturer: "Toyota", customerID: customerID)
        try carService.deleteCar(car)
        let deletedCar = try carService.fetchCar(byCarNumber: "1A-12345")
        XCTAssertNil(deletedCar)
    }

    func testCreateCustomer() throws {
        let customer = try customerService.createCustomer(firstName: "Tom", lastName: "Cruise", phoneNumber: "09250384832")
        XCTAssertEqual(customer.firstName, "Tom")
        XCTAssertEqual(customer.lastName, "Cruise")
        XCTAssertEqual(customer.phoneNumber, "09250384832")
    }

    func testFetchAllCustomers() throws {
        try customerService.deleteAllCustomers()
        _ = try customerService.createCustomer(firstName: "Kyaw", lastName: "Gyi", phoneNumber: "092342343432")
        let customers = try customerService.fetchAllCustomers()
        XCTAssertEqual(customers.count, 1)
    }


    func testFetchCustomerByID() throws {
        let customer = try customerService.createCustomer(firstName: "Doctor", lastName: "Dre", phoneNumber: "09448015487")
        let fetchedCustomer = try customerService.fetchCustomer(byID: customer.customerID)
        XCTAssertNotNil(fetchedCustomer)
        XCTAssertEqual(fetchedCustomer?.firstName, "Doctor")
    }

    func testUpdateCustomer() throws {
        try customerService.deleteAllCustomers()
        let customer = try customerService.createCustomer(firstName: "Snoop", lastName: "Dog", phoneNumber: "09442233413")
        try customerService.updateCustomer(customer, firstName: "Snoop")
        let updatedCustomer = try customerService.fetchCustomer(byID: customer.customerID)
        XCTAssertNotNil(updatedCustomer)
        XCTAssertEqual(updatedCustomer?.firstName, "Snoop")
    }

    func testDeleteCustomer() throws {
        let customer = try customerService.createCustomer(firstName: "Taylor", lastName: "Swift", phoneNumber: "098342234311")
        try customerService.deleteCustomer(customer)
        let deletedCustomer = try customerService.fetchCustomer(byID: customer.customerID)
        XCTAssertNil(deletedCustomer)
    }
}
