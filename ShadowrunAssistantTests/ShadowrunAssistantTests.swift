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
                .modifier(for: AttributeInfo.reaction.name(), value: 2)
            .attribute(AttributeInfo.strength, with: 6)
            .attribute(AttributeInfo.willpower, with: 4)
            .build()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCheckInitiativeIsCorrectlyRolled() throws {
        engine.setDie(type: CriticalFailureD6())
        var initiative = try engine.rollInitiative(character: zetsubo, usingEdge: false)
        let base = zetsubo.attribute(.reaction).rollingValue + zetsubo.attribute(.intuition).rollingValue
        XCTAssert(initiative == base, "Initiative with no successes and no edge should be the base initiative")

        engine.setDie(type: CriticalSuccessD6())
        initiative = try engine.rollInitiative(character: zetsubo, usingEdge: false)
        XCTAssert(initiative == base * 2, "Initiative with all successes and no edge should be twice the base initiative")

        engine.setDie(type: FromListD6(rolls: [1, 2, 3, 4, 5, 6, 1, 2, 3]))
        initiative = try engine.rollInitiative(character: zetsubo, usingEdge: false)
        XCTAssert(initiative == base + 2, "Initiative with 2 successes and no edge should be the base + 2")

        // rolling initiative with reaction 5 + 2 modifier + intuition 4 + edge 3
        engine.setDie(type: FromListD6(rolls: [1, 2, 3, 4, 5, 6, 1, 2, 3, 2, 2, 2, 2, 3, 6, 5]))
        initiative = try engine.rollInitiative(character: zetsubo, usingEdge: true)
        XCTAssert(initiative == base + 4)
    }

    func testRollingValueIsCorrect() {
        let value = zetsubo.attribute(.reaction).rollingValue
        XCTAssert(value == 7)
    }

    func testSkillRollIsCorrect() {

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
    
    private class FromListD6 : Die {
        private let rolls: [UInt32]
        private var index: Int = 0
        
        init(rolls: [UInt32]) {
            self.rolls = rolls
        }
        
        override func roll() -> UInt32 {
            let result = rolls[index]
            index += 1
            index %= rolls.count
            return result
        }
    }
}
