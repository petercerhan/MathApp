//
//  PrepareFeedViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class PrepareFeedViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: PrepareFeedViewModel
    
    //MARK: - Initialization
    
    init(viewModel: PrepareFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "PrepareFeedViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }

}

