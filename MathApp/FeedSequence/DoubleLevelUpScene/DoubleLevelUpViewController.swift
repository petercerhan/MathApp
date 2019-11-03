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
    
    //MARK: - Initialization
    
    init(viewModel: DoubleLevelUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DoubleLevelUpViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }

}
