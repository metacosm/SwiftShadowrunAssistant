//
// Created by Christophe Laprun on 06/01/2017.
// Copyright (c) 2017 Christophe Laprun. All rights reserved.
//

import XCTest
@testable import ShadowrunAssistant

class DieTests: XCTestCase {

    func testDieIsWithinBounds() {
        let die = Die()
        for _ in 0..<10000 {
            XCTAssert(die.min <= die.roll() && die.roll() <= die.max)
        }
    }
}
