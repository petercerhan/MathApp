//
//  PracticeIntroViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/29/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PracticeIntroViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: PracticeIntroViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var nextButton: UIButton!
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: PracticeIntroViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "PracticeIntroViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }
    
    //MARK: - UIViewController Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
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
