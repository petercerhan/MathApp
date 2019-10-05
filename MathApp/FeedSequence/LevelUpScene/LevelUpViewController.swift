//
//  LevelUpViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/2/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LevelUpViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: LevelUpViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var levelUpLabel: UILabel!
    @IBOutlet private(set) var conceptLabel: UILabel!
    @IBOutlet private(set) var nextButton: UIButton!
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
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
        bindActions()
    }
    
    private func bindUI() {
        levelUpLabel.text = "Level *\(viewModel.previousLevel)* to level *\(viewModel.newLevel)*"
        conceptLabel.text = viewModel.conceptName
    }
    
    private func bindActions() {
        nextButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .next)
            })
            .disposed(by: disposeBag)
    }

}
