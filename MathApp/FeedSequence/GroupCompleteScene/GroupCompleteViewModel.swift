//
//  GroupCompleteViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol GroupCompleteViewModelDelegate: class {
    func nextGroup(_ groupCompleteViewModel: GroupCompleteViewModel)
}

enum GroupCompleteAction {
    case nextGroup
}

class GroupCompleteViewModel {
    
    //MARK: - Dependencies
    
    private weak var delegate: GroupCompleteViewModelDelegate?
    
    //MARK: - Initialization
    
    init(delegate: GroupCompleteViewModelDelegate, groupCompleteItem: GroupCompleteTransitionItem) {
        self.delegate = delegate
        completedGroupName = groupCompleteItem.completedConceptGroup.name
        nextGroupName = groupCompleteItem.nextConceptGroup.name
    }
    
    //MARK: - GroupCompleteViewModel Interface
    
    let completedGroupName: String
    let nextGroupName: String
    
    func dispatch(action: GroupCompleteAction) {
        switch action {
        case .nextGroup:
            handle_nextGroup()
        }
    }
    
    private func handle_nextGroup() {
        delegate?.nextGroup(self)
    }
    
}
