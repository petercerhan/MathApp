//
//  UIView+addShadow.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/20/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.00)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
    }
    
    func removeShadow() {
        layer.shadowOpacity = 0.0
    }
}
