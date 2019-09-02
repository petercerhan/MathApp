//
//  FeedContainerViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class FeedContainerViewController: ContainerViewController {
    
    //MARK: - UI Components
    
    @IBOutlet private(set) var containerContentView: UIView!
    @IBOutlet private(set) var menuButton: UIButton!
    @IBOutlet private(set) var pointsLabel: UILabel!
    
    override var contentView: UIView {
        return containerContentView
    }
    
    //MARK: - Initialization
    
    init() {
        super.init(nibName: "FeedContainerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used. Use init(viewModel:) instead")
    }

}
