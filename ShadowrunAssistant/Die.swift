//
//  Die.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 04/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class Die {
    let threshold: Int
    let max: Int
    let min: Int
    
    init(min: Int = 1, max: Int = 6, threshold: Int = 5) {
        self.min = min
        self.max = max
        self.threshold = threshold
    }
    
    func roll() -> Int {
        return 1
    }
}
