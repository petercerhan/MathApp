//
//  ConceptMapViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ConceptMapViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: ConceptMapViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var backButton: UIButton!
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: ConceptMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ConceptMapViewController", bundle: nil)
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
        backButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .back)
            })
            .disposed(by: disposeBag)
    }

}
