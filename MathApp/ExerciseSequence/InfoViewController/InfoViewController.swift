//
//  InfoViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import iosMath
import RxSwift
import RxCocoa

class InfoViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: InfoViewModel
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var quitButton: UIButton!
    @IBOutlet private(set) var scrollView: UIScrollView!
    
    //MARK: - Rx
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization
    
    init(viewModel: InfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "InfoViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }
    
    //MARK: - UIViewController Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContentGlyphs()
        bindActions()
    }
    
    private func layoutContentGlyphs() {
        var bottomView: UIView?
        
        let contentElements = viewModel.infoViewContent
        
        for element in contentElements {
            if element.contentType == .text {
                let glyph = insertLabelGlyph(contentElement: element, bottomView: bottomView)
                bottomView = glyph
            } else {
                let glyph = insertLatexGlyph(contentElement: element, bottomView: bottomView)
                bottomView = glyph
            }
        }
        
        if let bottomView = bottomView {
            bottomView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -12.0).isActive = true
        }
    }
    
    private func insertLatexGlyph(contentElement: InfoViewContentElement, bottomView: UIView?) -> MTMathUILabel {
        let label = MTMathUILabel()
        label.latex = contentElement.content
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        
        if let bottomView = bottomView {
            label.topAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: 12.0).isActive = true
        } else {
            label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12.0).isActive = true
        }
        
        label.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12.0).isActive = true
        label.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 12.0).isActive = true
        
        return label
    }
    
    private func insertLabelGlyph(contentElement: InfoViewContentElement, bottomView: UIView?) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = contentElement.content
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        
        if let bottomView = bottomView {
            label.topAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: 12.0).isActive = true
        } else {
            label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12.0).isActive = true
        }
        
        label.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12.0).isActive = true
        label.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 12.0).isActive = true
        
        return label
    }
    
    private func bindActions() {
        quitButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.dispatch(action: .quit)
            })
            .disposed(by: disposeBag)
    }
    
}
