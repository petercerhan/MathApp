//
//  Queue.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/17/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

struct Queue<T> {
    
    private var array = [T]()
    
    var count: Int {
        return array.count
    }
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    mutating func enqueue(elements: [T]) {
        array.append(contentsOf: elements)
    }
    
    mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    func elementAt(_ index: Int) -> T? {
        if count > index {
            return array[index]
        } else {
            return nil
        }
    }
    
}
