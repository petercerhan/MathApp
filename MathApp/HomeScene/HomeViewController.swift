//
//  HomeViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var questionLabel: UILabel!
    @IBOutlet private(set) var answer1Button: UIButton!
    @IBOutlet private(set) var answer2Button: UIButton!
    @IBOutlet private(set) var answer3Button: UIButton!
    
    //MARK: - Initialization
    
    init() {
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }

}
