//
//  String.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation

extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        let phoneNumberRegEx = "^(\\+?[0-9]{1,4})?[-\\s]?([0-9]{10,15})$"
        let phoneNumberTest = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegEx)
        return phoneNumberTest.evaluate(with: self)
    }
}
