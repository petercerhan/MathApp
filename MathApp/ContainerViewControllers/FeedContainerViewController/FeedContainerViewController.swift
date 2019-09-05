//
//  FeedContainerViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FeedContainerViewController: ContainerViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: FeedContainerViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var containerContentView: UIView!
    @IBOutlet private(set) var menuButton: UIButton!
    @IBOutlet private(set) var pointsLabel: UILabel!
    
    override var contentView: UIView {
        return containerContentView
    }
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: FeedContainerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "FeedContainerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used. Use init(viewModel:) instead")
    }
    
    //MARK: - UIViewController Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

    private func bindUI() {
        viewModel.points
            .observeOn(MainScheduler.instance)
            .map { "\($0)" }
            .bind(to: pointsLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
