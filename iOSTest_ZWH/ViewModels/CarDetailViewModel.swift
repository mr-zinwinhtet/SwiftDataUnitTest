//
//  CarDetailViewModel.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation

class CarDetailViewModel {
    
    var cars: [Car] = []
    var onCarsUpdated: (() -> ())?
    var onError: ((Error) -> ())?
    
    private let carService: CarService
    
    init(carService: CarService) {
        self.carService = carService
    }
    
    func createCar(carNumber: String, carType: String, manufacturer: String, customerID: UUID) {
        do {
            guard try !carService.isCarNumberAlreadyExisted(carNumber) else {
                throw ValidationError.duplicateField("Car Number already exists.")
            }
            let _ = try carService.createCar(carNumber: carNumber, carType: carType, manufacturer: manufacturer, customerID: customerID)
            onCarsUpdated?()
        } catch {
            onError?(error)
        }
    }
    
    func updateCar(_ car: Car, carNumber: String, carType: String, manufacturer: String) {
        do {
            try carService.updateCar(car, carNumber: carNumber, carType: carType, manufacturer: manufacturer)
            onCarsUpdated?()
            
        } catch {
            onError?(error)
        }
    }
    
    func deleteCar(_ car: Car) {
        do {
            try carService.deleteCar(car)
            onCarsUpdated?()
        } catch {
            onError?(error)
        }
    }
    
}
