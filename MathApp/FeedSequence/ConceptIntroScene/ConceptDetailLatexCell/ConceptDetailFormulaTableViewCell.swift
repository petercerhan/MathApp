//
//  ConceptDetailFormulaTableViewCell.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/20/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import iosMath

class ConceptDetailFormulaTableViewCell: UITableViewCell {

    let formulaLabel = MTMathUILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        formulaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(formulaLabel)
        
        formulaLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        formulaLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        formulaLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        formulaLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
}
