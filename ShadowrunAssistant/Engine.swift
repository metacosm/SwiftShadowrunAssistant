//
//  Engine.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

class Engine {
    static let attributeNamesAndOrder = ["Body", "Agility", "Reaction", "Strength", "Willpower", "Logic", "Intuition", "Charisma", "Edge"]

    func attributeNames() -> [String] {
        return Engine.attributeNamesAndOrder
    }

    func createCharacter() -> Character {
        var builder = CharacterBuilder()
        
        Engine.attributeNamesAndOrder.forEach {
            builder.attribute(named: $0, with: 3)
        }
        
        return builder.build()
    }
    
    func rollInitiative(character: Character, usingEdge: Bool) throws -> Int {
        let reaction = try character.attribute(named: "Reaction")
        let intuition = try character.attribute(named: "Intuition")
        
        let initiativeDice = reaction.modifiedValue + intuition.modifiedValue
        let result = roll(dices: [Die](repeating: Engine.die6, count: initiativeDice), usingEdge: usingEdge)
        
        return initiativeDice + result.successes
    }

    func roll(dices: [Die], usingEdge: Bool) -> RollResult {
        let results = RollResult(dices: dices)
        
        if(usingEdge) {
            return results + roll(dices: [Die](repeating: Engine.die6, count: results.criticalSuccesses), usingEdge: true)
        }
        
        return results
    }

    struct Die {
        let threshold: Int
        let max: Int
        let min: Int
        func roll() -> Int {
            return 1
        }
    }
    
    static let die6 = Die(threshold: 5, max: 6, min: 1)

    class RollResult {
        let rolls: [Int]
        let successes: Int
        let failures: Int
        let criticalFailures: Int
        let criticalSuccesses: Int

        init(dices: [Die]) {
            var results = (successes: 0, failures: 0, criticalSuccesses: 0, criticalFailures: 0)

            self.rolls = dices.map({
                let die = $0
                let roll = die.roll()
                if (roll < die.threshold) {
                    results.failures += 1
                    if (roll == die.min) {
                        results.criticalFailures += 1
                    } else {
                        results.successes += 1
                        if (roll == die.max) {
                            results.criticalSuccesses += 1
                        }
                    }
                }
                return roll
            })

            (self.successes, self.failures, self.criticalSuccesses, self.criticalFailures) = results
        }
        
        fileprivate init(rolls: [Int], successes: Int, failures: Int, criticalSuccesses: Int, criticalFailures: Int) {
            self.rolls = rolls
            self.successes = successes
            self.failures = failures
            self.criticalSuccesses = criticalSuccesses
            self.criticalFailures = criticalFailures
        }

        static func + (left: RollResult, right: RollResult) -> RollResult {
            return RollResult(rolls: left.rolls + right.rolls, successes: left.successes + right.successes, failures: left.failures + right.failures, criticalSuccesses: left.criticalSuccesses + right.criticalSuccesses, criticalFailures: left.criticalFailures + right.criticalFailures)
        }

    }
    
    enum EngineError: Error {
        case invalidAttribute
    }
}
