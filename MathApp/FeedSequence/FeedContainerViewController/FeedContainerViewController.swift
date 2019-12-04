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
    
    let viewModel: FeedContainerViewModel
    private let resultsStore: ResultsStore
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var containerContentView: UIView!
    @IBOutlet private(set) var menuButton: UIButton!
    @IBOutlet private(set) var progressView: UIView!
    @IBOutlet private(set) var progressViewOutline: UIView!
    
    @IBOutlet private(set) var progressWidth: NSLayoutConstraint!
    
    override var contentView: UIView {
        return containerContentView
    }
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: FeedContainerViewModel, resultsStore: ResultsStore) {
        self.viewModel = viewModel
        self.resultsStore = resultsStore
        super.init(nibName: "FeedContainerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used. Use init(viewModel:) instead")
    }
    
    //MARK: - UIViewController Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bindActions()
    }
    
    private func configureUI() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func bindUI() {
        viewModel.progressRatio
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] progressRatio in
                self.updateProgressView(progressRatio: progressRatio)
            })
            .disposed(by: disposeBag)
        
        viewModel.progressRatio
            .skip(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] progressRatio in
                self.updateProgressViewAnimated(progressRatio: progressRatio)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateProgressView(progressRatio: Double) {
        progressWidth.isActive = false
        progressWidth = progressView.widthAnchor.constraint(equalTo: progressViewOutline.widthAnchor, multiplier: CGFloat(progressRatio))
        progressWidth.isActive = true
    }
    
    private func updateProgressViewAnimated(progressRatio: Double) {
        let priorRatio = Double(progressWidth.multiplier)
        
        progressWidth.isActive = false
        
        progressWidth = progressView.widthAnchor.constraint(equalTo: progressViewOutline.widthAnchor, multiplier: CGFloat(progressRatio))
        progressWidth.isActive = true
        
        if priorRatio == 1, progressRatio == 0 {
            return
        }
        
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    private func bindActions() {
        menuButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .menu)
            })
            .disposed(by: disposeBag)
    }
    
}
