//
//  Die.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 04/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class Die {
    let threshold: UInt32
    let max: UInt32
    let min: UInt32
    
    init(min: UInt32 = 1, max: UInt32 = 6, threshold: UInt32 = 5) {
        assert(min <= max)
        self.min = min
        self.max = max
        self.threshold = threshold
    }
    
    func roll() -> UInt32 {
        return arc4random_uniform(max - min + 1) + min
    }
}
