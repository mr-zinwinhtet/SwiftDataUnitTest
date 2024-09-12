//
//  Car.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation
import SwiftData


@Model
class Car {
    @Attribute(.unique)
    var carNumber: String
    var carType: String
    var manufacturer: String
    
    // toOne
    var customerID: UUID

    init(carNumber: String, carType: String, manufacturer: String, customerID: UUID) {
        self.carNumber = carNumber
        self.carType = carType
        self.manufacturer = manufacturer
        self.customerID = customerID
    }
}
