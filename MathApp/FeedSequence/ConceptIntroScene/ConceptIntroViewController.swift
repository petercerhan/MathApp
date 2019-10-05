//
//  ConceptIntroViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import iosMath
import RxSwift
import RxCocoa

class ConceptIntroViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: ConceptIntroViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var conceptNameLabel: UILabel!
    @IBOutlet private(set) var conceptDescriptionLabel: UILabel!
    @IBOutlet private(set) var ruleLatexLabel: MTMathUILabel!
    @IBOutlet private(set) var nextButton: UIButton!
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: ConceptIntroViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ConceptIntroViewController", bundle: nil)
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
        conceptNameLabel.text = viewModel.name
        conceptDescriptionLabel.text = viewModel.description
        ruleLatexLabel.latex = viewModel.ruleLatex
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


