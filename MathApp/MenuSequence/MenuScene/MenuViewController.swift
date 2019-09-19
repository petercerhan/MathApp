//
//  MenuViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: MenuViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var conceptMapButton: UIButton!
    @IBOutlet private(set) var resetDBButton: UIButton!
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "MenuViewController", bundle: nil)
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
        conceptMapButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .conceptMap)
            })
            .disposed(by: disposeBag)
        
        resetDBButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .resetDB)
            })
            .disposed(by: disposeBag)
    }

}
