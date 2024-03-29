//
//  QuitableContainerViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class QuitableContainerViewController: ContainerViewController {
    
    //MARK: - Dependencies
    
    let viewModel: QuitableContainerViewModel
    
    //MARK: - Interface Components
    
    @IBOutlet private(set) var quitButton: UIButton!
    @IBOutlet private(set) var containerContentView: UIView!
    
    override var contentView: UIView {
        return containerContentView
    }
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: QuitableContainerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "QuitableContainerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used. Use init(viewModel:) instead")
    }
    
    //MARK: - UIViewController Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }
    
    private func bindActions() {
        quitButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .quit)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - QuitableWorldViewControllerInterface
    
    func setDelegate(_ delegate: QuitableContainerViewModelDelegate) {
        viewModel.setDelegate(delegate)
    }
    
}
