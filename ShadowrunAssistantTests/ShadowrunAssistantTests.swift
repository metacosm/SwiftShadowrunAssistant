//
//  ShadowrunAssistantTests.swift
//  ShadowrunAssistantTests
//
//  Created by Christophe Laprun on 14/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import XCTest
@testable import ShadowrunAssistant

typealias DicePool = UInt
typealias DiceValue = UInt32

class ShadowrunAssistantTests: XCTestCase {
    private var engine: Engine! = nil
    private var zetsubo: ShadowrunAssistant.Character! = nil
    private var dieType: Die = CriticalFailureD6()
    private var katana: SkillInfo! = nil

    override func setUp() {
        super.setUp()

        engine = Engine()
        zetsubo = engine.characterRegistry().zetsubo()
        katana = engine.skillRegistry().skill(named: "katana")!
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCheckInitiativeIsCorrectlyRolled() throws {
        engine.setDie(type: CriticalFailureD6())
        var initiative = engine.rollInitiative(character: zetsubo, usingEdge: false)
        let base = zetsubo.dicePoolSize(for: AttributeInfo.reaction) + zetsubo.dicePoolSize(for: AttributeInfo.intuition)
        XCTAssert(initiative == base, "Initiative with no successes and no edge should be the base initiative " +
                "(\(base)). Got: \(initiative)")

        engine.setDie(type: CriticalSuccessD6())
        initiative = engine.rollInitiative(character: zetsubo, usingEdge: false)
        XCTAssert(initiative == base * 2, "Initiative with all successes and no edge should be twice the base " +
                "initiative (\(2 * base)). Got: \(initiative)")

        var rolls: [DiceValue] = [1, 2, 3, 4, 5, 6, 1, 2, 3]
        engine.setDie(type: FromListD6(rolls: rolls))
        initiative = engine.rollInitiative(character: zetsubo, usingEdge: false)
        XCTAssert(initiative == base + 2, "Initiative with 2 successes and no edge should be the base + 2 " +
                "(\(base + 2)). Got: \(initiative)")

        // rolling initiative with reaction 5 + 2 modifier + DicePooluition 4 + edge 3
        rolls = [1, 2, 3, 4, 5, 6, 1, 2, 3, 2, 2, 2, 2, 3, 6, 5]
        engine.setDie(type: FromListD6(rolls: rolls))
        initiative = engine.rollInitiative(character: zetsubo, usingEdge: true)
        XCTAssert(initiative == base + 4)
    }

    func testDicePoollSizeIsCorrect() {
        let value = zetsubo.dicePoolSize(for: AttributeInfo.reaction)
        XCTAssert(value == 7)
    }

    func testSkillRollIsCorrect() throws {
        let toRoll = zetsubo.dicePoolSize(for: katana)
        let skill = zetsubo.skill(katana)!
        let linkedAttribute = zetsubo.dicePoolSize(for: skill.linkedCharacteristic())
        XCTAssert(toRoll == linkedAttribute + skill.modifiedValue())
        XCTAssert(toRoll == 14)

        engine.setDie(type: CriticalFailureD6())
        XCTAssert(engine.roll(katana, for: zetsubo).successes == 0)
        XCTAssert(engine.roll(katana, for: zetsubo).failures == toRoll)

        let die = InstrumentedD6()
        engine.setDie(type: die)
        let result = engine.roll(katana, for: zetsubo)
        XCTAssert(result.successes == die.successses())
        XCTAssert(result.failures == die.failures())
        XCTAssert(toRoll == die.timesRolled())
        XCTAssert(result.failures + result.successes == toRoll)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    private class CriticalFailureD6: Die {
        override func roll() -> DiceValue {
            return 1
        }
    }

    private class CriticalSuccessD6: Die {
        override func roll() -> DiceValue {
            return 6
        }
    }

    private class FromListD6: Die {
        private let rolls: [DiceValue]
        private var index = 0

        init(rolls: [DiceValue]) {
            self.rolls = rolls
        }

        override func roll() -> DiceValue {
            let result = rolls[index]
            index += 1
            index %= rolls.count
            return result
        }
    }

    private class InstrumentedD6: Die {
        private var _successes: DicePool = 0
        private var _failures: DicePool = 0
        private var numberOfRolls: DicePool = 0

        func successses() -> DicePool {
            return _successes
        }

        func failures() -> DicePool {
            return _failures
        }

        func timesRolled() -> DicePool {
            return numberOfRolls
        }

        override func roll() -> DiceValue {
            let result = super.roll()
            if (result >= 5) {
                _successes += 1
            } else {
                _failures += 1
            }
            numberOfRolls += 1

            return result
        }

    }

}
