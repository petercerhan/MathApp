//
//  DoubleLevelUpViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/2/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class DoubleLevelUpViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: DoubleLevelUpViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var rule1Label: UILabel!
    @IBOutlet private(set) var rule1LevelLabel: UILabel!
    @IBOutlet private(set) var rule2Label: UILabel!
    @IBOutlet private(set) var rule2LevelLabel: UILabel!
    
    //MARK: - Initialization
    
    init(viewModel: DoubleLevelUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DoubleLevelUpViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }
    
    //MARK: - UIViewController Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
