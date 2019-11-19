//
//  GroupCompleteViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GroupCompleteViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: GroupCompleteViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var messageLabel: UILabel!
    @IBOutlet private(set) var nextGroupButton: UIButton!
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: GroupCompleteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "GroupCompleteViewController", bundle: nil)
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
        messageLabel.text = "You've completed: \(viewModel.completedGroupName)"
        nextGroupButton.setTitle("Next: \(viewModel.nextGroupName)", for: .normal)
    }
    
    private func bindActions() {
        nextGroupButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .nextGroup)
            })
            .disposed(by: disposeBag)
    }

}
