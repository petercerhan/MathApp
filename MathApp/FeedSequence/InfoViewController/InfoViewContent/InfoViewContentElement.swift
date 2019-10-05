//
//  InfoViewContent.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/6/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

enum InfoViewContentType {
    case text
    case latex
}

struct InfoViewContentElement {
    let contentType: InfoViewContentType
    let content: String
}
