//
//  ExerciseViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExerciseViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: ExerciseViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var choice1Button: UIButton!
    @IBOutlet private(set) var choice2Button: UIButton!
    @IBOutlet private(set) var choice3Button: UIButton!
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: ExerciseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ExerciseViewController", bundle: nil)
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
        viewModel.choice1
            .observeOn(MainScheduler.instance)
            .bind(to: choice1Button.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.choice2
            .observeOn(MainScheduler.instance)
            .bind(to: choice2Button.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.choice3
            .observeOn(MainScheduler.instance)
            .bind(to: choice3Button.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }

}
