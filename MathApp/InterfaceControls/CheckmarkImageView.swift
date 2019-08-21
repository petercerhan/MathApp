//
//  CheckmarkImageView.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/21/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class CheckmarkImageView: UIImageView {
    
    private(set) var isCorrect = true
    
    func setIsCorrect(_ isCorrect: Bool) {
        self.isCorrect = isCorrect
        if isCorrect {
            self.image = UIImage(named: "Checkmark")
        } else {
            self.image = UIImage(named: "X")
        }
    }
    
}
