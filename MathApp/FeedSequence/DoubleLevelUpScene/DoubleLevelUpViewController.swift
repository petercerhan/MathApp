//
//  DoubleLevelUpViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/2/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DoubleLevelUpViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: DoubleLevelUpViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var nextButton: UIButton!
    @IBOutlet private(set) var rule1Label: UILabel!
    @IBOutlet private(set) var rule1LevelLabel: UILabel!
    @IBOutlet private(set) var rule2Label: UILabel!
    @IBOutlet private(set) var rule2LevelLabel: UILabel!
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
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
        configureUI()
        bindActions()
    }
    
    private func configureUI() {
        rule1Label.text = viewModel.concept1Name
        rule1LevelLabel.text = "Level \(viewModel.concept1PriorLevel) to \(viewModel.concept1NewLevel)"
        rule2Label.text = viewModel.concept2Name
        rule2LevelLabel.text = "Level \(viewModel.concept2PriorLevel) to \(viewModel.concept2NewLevel)"
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
