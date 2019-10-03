//
//  LevelUpViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/2/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class LevelUpViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: LevelUpViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var levelUpLabel: UILabel!
    @IBOutlet private(set) var conceptLabel: UILabel!
    
    //MARK: - Initialization
    
    init(viewModel: LevelUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LevelUpViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }
    
    //MARK: - UIViewController Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    private func bindUI() {
        levelUpLabel.text = "Level *\(viewModel.previousLevel)* to level *\(viewModel.newLevel)*"
        conceptLabel.text = viewModel.conceptName
    }

}
