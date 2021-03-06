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
    private var zetsubo: Shadowrunner! = nil
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
   
   func testModifiedValue() {
      let builder = engine.characterRegistry().getCharacterBuilder(characterNamed: "foo")
       let char = try! builder.attribute(Engine.strength, with: 3)
         .attribute(Engine.body, with: 2)
         .build()

      XCTAssert(char.attribute(Engine.strength).baseValue == 3)
      XCTAssert(char.attribute(Engine.body).baseValue == 2)

      let liftAndCarry = char.attribute(Engine.liftCarry)
      
      XCTAssert(liftAndCarry.info is DerivedAttributeInfo)
      let derivedInfo = liftAndCarry.info as! DerivedAttributeInfo

      XCTAssert(char.attribute(Engine.strength).baseValue == 3)
      XCTAssert(char.attribute(Engine.body).baseValue == 2)

      let first = char.attribute(derivedInfo.first)
      let second = char.attribute(derivedInfo.second)
      XCTAssert(liftAndCarry.baseValue == first.baseValue + second.baseValue)
   }

    func testCheckInitiativeIsCorrectlyRolled() throws {
        engine.setDie(type: CriticalFailureD6())
        var initiative = engine.rollInitiative(for: zetsubo, usingEdge: false)
        let base = zetsubo.dicePool(for: Engine.reaction) + zetsubo.dicePool(for: Engine.intuition)
        XCTAssert(initiative == base, "Initiative with no successes and no edge should be the base initiative " +
                "(\(base)). Got: \(initiative)")

        engine.setDie(type: CriticalSuccessD6())
        initiative = engine.rollInitiative(for: zetsubo, usingEdge: false)
        XCTAssert(initiative == base * 2, "Initiative with all successes and no edge should be twice the base " +
                "initiative (\(2 * base)). Got: \(initiative)")

        var rolls: [DiceValue] = [1, 2, 3, 4, 5, 6, 1, 2, 3]
        engine.setDie(type: FromListD6(rolls: rolls))
        initiative = engine.rollInitiative(for: zetsubo, usingEdge: false)
        XCTAssert(initiative == base + 2, "Initiative with 2 successes and no edge should be the base + 2 " +
                "(\(base + 2)). Got: \(initiative)")

        // rolling initiative with reaction 5 + 2 modifier + intuition 4 + edge 3
        rolls = [1, 2, 3, 4, 5, 6, 1, 2, 3, 2, 2, 2, 2, 3, 6, 5]
        engine.setDie(type: FromListD6(rolls: rolls))
        initiative = engine.rollInitiative(for: zetsubo, usingEdge: true)
        XCTAssert(initiative == base + 4)
    }

    func testDicePoollSizeIsCorrect() {
        let value = zetsubo.dicePool(for: Engine.reaction)
        XCTAssert(value == 7)
    }

    func testSkillRollIsCorrect() throws {
        let toRoll = zetsubo.dicePool(for: katana)
        let skill = zetsubo.skill(katana)
        let linkedAttribute = zetsubo.dicePool(for: katana.linkedAttribute)
        XCTAssert(toRoll == linkedAttribute + skill.modifiedValue)
        XCTAssert(toRoll == 14)

        engine.setDie(type: CriticalFailureD6())
        XCTAssert(engine.roll(skill).successes == 0)
        XCTAssert(engine.roll(skill).failures == toRoll)

        let die = InstrumentedD6()
        engine.setDie(type: die)
        let result = engine.roll(skill)
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
