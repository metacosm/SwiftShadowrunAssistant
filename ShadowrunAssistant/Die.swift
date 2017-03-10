//
//  Die.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 04/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

public typealias DieValue = UInt32

class Die {
   let threshold: DieValue
   let max: DieValue
   let min: DieValue

   init(min: DieValue = 1, max: DieValue = 6, threshold: DieValue = 5) {
      assert(min <= max)
      self.min = min
      self.max = max
      self.threshold = threshold
   }

   func roll() -> DieValue {
      return arc4random_uniform(max - min + 1) + min
   }
}
