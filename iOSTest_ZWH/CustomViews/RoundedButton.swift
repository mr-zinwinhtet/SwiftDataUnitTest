//
//  RoundedButton.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpButton()
    }
    
    private func setUpButton() {
        layer.cornerRadius = 10.0
        backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        setTitleColor(.white, for: .normal)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4.0
        tintColor = .white
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24)
        configuration.imagePadding = 4
        self.configuration = configuration
    }
    
}
