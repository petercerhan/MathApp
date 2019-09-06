//
//  InfoViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol InfoViewModelDelegate: class {
    func quit(_ infoViewModel: InfoViewModel)
}

class InfoViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: InfoViewModelDelegate?
    
    //MARK: - Initialization
    
    init(delegate: InfoViewModelDelegate) {
        self.delegate = delegate
    }

}

