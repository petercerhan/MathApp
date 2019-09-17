//
//  LoadExercisesViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class LoadExercisesViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: LoadExercisesViewModel
    
    //MARK: - Initialization
    
    init(viewModel: LoadExercisesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoadExercisesViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }

}
