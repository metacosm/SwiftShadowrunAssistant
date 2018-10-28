//
//  EngineTests.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 03/04/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import XCTest

@testable import ShadowrunAssistant

class EngineTests: XCTestCase {

    func testDieIsWithinBounds() {
        let engine = Engine()
        let zetsubo = engine.characterRegistry().zetsubo()
        let agility = zetsubo.attribute(Engine.agility)

        for _ in 0..<10000 {
            let _ = engine.roll(agility)
        }

        let expected = Float(agility.dicePool) / 3
        if let stats = engine.stats(for: agility) {
            let avg = stats.mean(of: stats.successes)
            print(expected)
            print(avg)
            XCTAssert(avg <= expected + 0.01 && avg >= expected - 0.01)
        }
    }
}
