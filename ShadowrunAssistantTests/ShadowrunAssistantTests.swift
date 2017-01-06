//
//  ShadowrunAssistantTests.swift
//  ShadowrunAssistantTests
//
//  Created by Christophe Laprun on 14/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import XCTest
@testable import ShadowrunAssistant

class ShadowrunAssistantTests: XCTestCase {
    private var engine: Engine! = nil
    private var zetsubo: ShadowrunAssistant.Character! = nil
    private var dieType: Die = CriticalFailureD6()

    override func setUp() {
        super.setUp()

        engine = Engine()
        let builder = CharacterBuilder()
        zetsubo = builder
            .attribute(AttributeInfo.agility, with: 5)
            .attribute(AttributeInfo.body, with: 6)
            .attribute(AttributeInfo.charisma, with: 2)
            .attribute(AttributeInfo.edge, with: 3)
            .attribute(AttributeInfo.intuition, with: 4)
            .attribute(AttributeInfo.logic, with: 3)
            .attribute(AttributeInfo.reaction, with: 5)
            .attribute(AttributeInfo.strength, with: 6)
            .attribute(AttributeInfo.willpower, with: 4)
            .build()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCheckInitiativeIsCorrectlyRolled() throws {
        var initiative = try engine.rollInitiative(character: zetsubo, usingEdge: false)
        let base = zetsubo.attribute(.reaction).modifiedValue + zetsubo.attribute(.intuition).modifiedValue
        XCTAssert(initiative == base)

        engine.setDie(type: CriticalSuccessD6())

        initiative = try engine.rollInitiative(character: zetsubo, usingEdge: false)
        XCTAssert(initiative == base * 2)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private class CriticalFailureD6 : Die {
        override func roll() -> UInt32 {
            return 1
        }
    }

    private class CriticalSuccessD6: Die {
        override func roll() -> UInt32 {
            return 6
        }
    }
}
