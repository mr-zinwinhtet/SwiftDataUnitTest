//
//  ViewController.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func createTextField(placeholder: String, imageName: String, keyboardType: UIKeyboardType = .default, returnKeyType: UIReturnKeyType = .default, isBecomeFirstResponder: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.returnKeyType = returnKeyType
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = .none
        textField.font = UIFont(name: "Poppins-Regular", size: 16)
        
        let imageView = UIImageView()
        let image = UIImage(systemName: imageName)
        imageView.image = image
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        textField.leftView = imageView
        textField.leftViewMode = .always
        textField.becomeFirstResponder()
        if isBecomeFirstResponder {
            textField.becomeFirstResponder()
        }
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
