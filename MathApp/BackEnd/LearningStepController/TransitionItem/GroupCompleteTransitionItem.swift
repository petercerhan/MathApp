//
//  GroupCompleteTransitionItem.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

struct GroupCompleteTransitionItem: TransitionItem {
    let completedConceptGroup: ConceptGroup
    let nextConceptGroup: ConceptGroup
}
