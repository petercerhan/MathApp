//
//  ConceptTableViewCell.swift
//  MathApp
//
//  Created by Peter Cerhan on 12/4/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class ConceptTableViewCell: UITableViewCell {
    
    @IBOutlet private(set) var iconImageView: UIImageView!
    @IBOutlet private(set) var nameLabel: UILabel!
    @IBOutlet private(set) var level1Bar: UIView!
    @IBOutlet private(set) var level2Bar: UIView!
    @IBOutlet private(set) var level3Bar: UIView!

    let levelBarGrey = UIColor(white: 0.89, alpha: 1.0)
    
    func setUIForStrength(_ strength: Int) {
        level1Bar.backgroundColor = levelBarGrey
        level2Bar.backgroundColor = levelBarGrey
        level3Bar.backgroundColor = levelBarGrey
        
        if strength > 0 {
            level1Bar.backgroundColor = Colors.lightBlue
        }
        if strength > 1 {
            level2Bar.backgroundColor = Colors.lightBlue
        }
        if strength > 2 {
            level3Bar.backgroundColor = Colors.lightBlue
        }
    }
    
}
