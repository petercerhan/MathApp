//
//  GroupCompleteViewModel.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class GroupCompleteViewModel {
    
    //MARK: - Initialization
    
    init(groupCompleteItem: GroupCompleteTransitionItem) {
        completedGroupName = groupCompleteItem.completedConceptGroup.name
        nextGroupName = groupCompleteItem.nextConceptGroup.name
    }
    
    //MARK: - GroupCompleteViewModel Interface
    
    let completedGroupName: String
    let nextGroupName: String
    
    
    
}
