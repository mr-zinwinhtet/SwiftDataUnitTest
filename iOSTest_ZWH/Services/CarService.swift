//
//  CarService.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation
import SwiftData

class CarService {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func createCar(carNumber: String, carType: String, manufacturer: String, customerID: UUID) throws -> Car {
        guard !carNumber.isEmpty else { throw ValidationError.emptyField("Car Number") }
        guard !carType.isEmpty else { throw ValidationError.emptyField("Car Type") }
        guard !manufacturer.isEmpty else { throw ValidationError.emptyField("Manufacturer") }
        
        guard try !isCarNumberAlreadyExisted(carNumber) else {
            throw ValidationError.duplicateField("Car Number")
        }
        
        let car = Car(carNumber: carNumber, carType: carType, manufacturer: manufacturer, customerID: customerID)
        context.insert(car)
        try saveContext()
        return car
    }
    
    func fetchAllCars() throws -> [Car] {
        do {
            return try context.fetch(FetchDescriptor<Car>())
        } catch {
            throw CoreDataError.fetchError(error.localizedDescription)
        }
    }
    
    func fetchCar(byCarNumber carNumber: String) throws -> Car? {
        let predicate = #Predicate<Car> { $0.carNumber == carNumber }
        let fetchDescriptor = FetchDescriptor<Car>(predicate: predicate)
        return try context.fetch(fetchDescriptor).first
    }
    
    func fetchCars(byCustomerID customerID: UUID) throws -> [Car] {
        let predicate = #Predicate<Car> { $0.customerID == customerID }
        let fetchDescriptor = FetchDescriptor<Car>(predicate: predicate)
        return try context.fetch(fetchDescriptor)
    }
    
    func updateCar(_ car: Car, carNumber: String? = nil, carType: String? = nil, manufacturer: String? = nil) throws {
        if let carNumber = carNumber, !carNumber.isEmpty {
            guard try !isCarNumberAlreadyExisted(carNumber) else {
                throw ValidationError.duplicateField("Car Number")
            }
            car.carNumber = carNumber
        } else if carNumber != nil {
            throw ValidationError.emptyField("Car Number")
        }
        if let carType = carType, !carType.isEmpty {
            car.carType = carType
        } else if carType != nil {
            throw ValidationError.emptyField("Car Type")
        }
        if let manufacturer = manufacturer, !manufacturer.isEmpty {
            car.manufacturer = manufacturer
        } else if manufacturer != nil {
            throw ValidationError.emptyField("Manufacturer")
        }
        try saveContext()
    }
    
    func deleteCar(_ car: Car) throws {
        context.delete(car)
        try saveContext()
    }
    
    // this one is only for Unit Testing purpose :3 
    func deleteAllCars() throws {
        let cars = try fetchAllCars()
        for car in cars {
            context.delete(car)
        }
        try saveContext()
    }
    
    func isCarNumberAlreadyExisted(_ carNumber: String) throws -> Bool {
        return try fetchCar(byCarNumber: carNumber) != nil
    }
    
    private func saveContext() throws {
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveError(error.localizedDescription)
        }
    }
}
