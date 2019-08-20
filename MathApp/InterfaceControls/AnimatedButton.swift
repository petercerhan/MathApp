//
//  AnimatedButton.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/20/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class AnimatedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 4.0
    @IBInspectable var borderWidth: CGFloat = 0.0
    @IBInspectable var borderColor: UIColor = UIColor.white
    @IBInspectable var hasShadow: Bool = true
    
    private var isInitialConfigurationComplete = false
    
    //MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isInitialConfigurationComplete {
            return
        } else {
            layer.cornerRadius = cornerRadius
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
            if hasShadow {
                addShadow()
            }
            isInitialConfigurationComplete = true
        }
    }
    
    //MARK: - Control Events
    
    override func beginTracking(_ touch: UITouch, with withEvent: UIEvent?) -> Bool {
        adjustContent(active: true)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        adjustContent(active: false)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        adjustContent(active: false)
    }
    
    private func adjustContent(active: Bool) {
        if active {
            center.x += 3.0
            center.y += 3.0
        } else {
            center.x -= 3.0
            center.y -= 3.0
        }
    }
}
