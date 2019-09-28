//
//  LoadState.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/28/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

enum LoadState<T> {
    case noData
    case loading
    case loaded(T)
    case error
    
    var isNoData: Bool {
        switch self {
        case .noData:
            return true
        default:
            return false
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
    
    var isLoaded: Bool {
        switch self {
        case .loaded:
            return true
        default:
            return false
        }
    }
    
    var isError: Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }
    
    var data: T? {
        switch self {
        case .loaded(let value):
            return value
        default:
            return nil
        }
    }
}
