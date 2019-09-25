//
//  ChooseExerciseViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/24/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChooseExerciseViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: ChooseExerciseViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var backButton: UIButton!
    @IBOutlet private(set) var textField: UITextField!
    @IBOutlet private(set) var submitButton: UIButton!
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: ChooseExerciseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ChooseExerciseViewController", bundle: nil)
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
        bindBackAction()
        bindSubmitAction()
    }
    
    private func bindBackAction() {
        backButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .back)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSubmitAction() {
        submitButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.submit()
            })
            .disposed(by: disposeBag)
    }
    
    private func submit() {
        guard let idString = textField.text, let id = Int(idString) else {
            return
        }
        viewModel.dispatch(action: .submit(id: id))
    }

}
