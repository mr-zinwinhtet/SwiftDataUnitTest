//
//  CellButton.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation
import UIKit

class CellButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height/2
        clipsToBounds = true
    }
    
    func setImage(systemName: String) {
        self.setImage(UIImage(systemName: systemName), for: .normal)
    }
    
    func setImage(image: UIImage) {
        self.setImage(image, for: .normal)
    }
    
}
