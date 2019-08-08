//
//  HomeViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import iosMath

class HomeViewController: UIViewController {
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var questionLabel: UILabel!
    @IBOutlet private(set) var answer1Button: UIButton!
    @IBOutlet private(set) var answer2Button: UIButton!
    @IBOutlet private(set) var answer3Button: UIButton!
    
    //MARK: - Initialization
    
    init() {
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("cannot initialize with init(coder:)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = MTMathUILabel(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
        label.latex = "x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
