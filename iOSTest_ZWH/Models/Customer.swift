//
//  Customer.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation
import SwiftData

@Model
class Customer {
    @Attribute(.unique)
    var customerID: UUID
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String?
    var address: String?

    @Relationship(deleteRule: .cascade)
    var cars: [Car] = []

    init(firstName: String, lastName: String, phoneNumber: String, email: String? = nil, address: String? = nil) {
        self.customerID = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.address = address
    }
}
