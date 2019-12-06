//
//  LevelUpViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/2/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LevelUpViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: LevelUpViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var conceptNameContainer: UIView!
    @IBOutlet private(set) var iconImageView: UIImageView!
    @IBOutlet private(set) var conceptLabel: UILabel!
    @IBOutlet private(set) var nextButton: UIButton!
    
    @IBOutlet private(set) var strength1Bar: UIView!
    @IBOutlet private(set) var strength2Bar: UIView!
    @IBOutlet private(set) var strength3Bar: UIView!

    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: LevelUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LevelUpViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }
    
    //MARK: - UIViewController Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bindActions()
    }
    
    private func configureUI() {
        conceptNameContainer.layer.borderColor = UIColor.systemBlue.cgColor
        conceptNameContainer.layer.cornerRadius = 8.0
        conceptNameContainer.layer.borderWidth = 1.0
        
        iconImageView.image = UIImage(named: viewModel.icon)
        
        configureStrengthBars()
    }
    
    private func configureStrengthBars() {
        setInitialStrengthBars()
        animateNewStrength()
    }
    
    private func setInitialStrengthBars() {
        if viewModel.previousLevel > 0 {
            strength1Bar.backgroundColor = Colors.lightBlue
        }
        if viewModel.previousLevel > 1 {
            strength2Bar.backgroundColor = Colors.lightBlue
        }
    }
    
    private func animateNewStrength() {
        let animationView = UIView()
        animationView.backgroundColor = Colors.lightBlue
        let newStrengthBar = self.newStrengthBar()
        newStrengthBar.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.leftAnchor.constraint(equalTo: newStrengthBar.leftAnchor).isActive = true
        animationView.rightAnchor.constraint(equalTo: newStrengthBar.rightAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: newStrengthBar.bottomAnchor).isActive = true
        let heightConstraint = animationView.heightAnchor.constraint(equalToConstant: 0.0)
        heightConstraint.isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) { [weak self] in
            self?.animateNewStrengthBar(animationView: animationView, heightConstraint: heightConstraint)
        }
    }
    
    private func animateNewStrengthBar(animationView: UIView, heightConstraint: NSLayoutConstraint) {
        let newStrengthView = newStrengthBar()
        
        heightConstraint.isActive = false
        animationView.topAnchor.constraint(equalTo: newStrengthView.topAnchor).isActive = true
        
        UIView.animate(withDuration: 0.55) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    private func newStrengthBar() -> UIView {
        if viewModel.newLevel == 1 {
            return strength1Bar
        } else if viewModel.newLevel == 2 {
            return strength2Bar
        } else {
            return strength3Bar
        }
    }
    
    private func bindUI() {
        conceptLabel.text = viewModel.conceptName
        iconImageView.image = UIImage(named: viewModel.icon)
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
