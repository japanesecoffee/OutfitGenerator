//
//  Queue.swift
//  OutfitGenerator
//
//  Created by Jason on 4/8/23.
//

import Foundation

struct Queue<T> {
    
    var array: [T] = []
    
    init() {}
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    var peek: T? {
        return array.first
    }
    
    mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    mutating func dequeue() {
        if !isEmpty {
            array.removeFirst(1)
        }
    }
}
