//
//  ConceptDetailLatexTableViewCell.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/20/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import iosMath

class ConceptDetailFormulaTableViewCell: UITableViewCell {

    let spacerView = UIView()
    let formulaLabel = MTMathUILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        formulaLabel.translatesAutoresizingMaskIntoConstraints = false
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(formulaLabel)
        contentView.addSubview(spacerView)
        
        spacerView.backgroundColor = UIColor.blue
        
        spacerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        spacerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        spacerView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        spacerView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        spacerView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        formulaLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        formulaLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        formulaLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        formulaLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
}
