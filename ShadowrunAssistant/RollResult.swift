//
//  RollResult.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 04/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

class RollResult {
    let rolls: [DicePool]
    let successes: DicePool
    let failures: DicePool
    let criticalFailures: DicePool
    let criticalSuccesses: DicePool

    init(dices: [Die]) {
        var results = (successes: DicePool(), failures: DicePool(), criticalSuccesses: DicePool(), criticalFailures:
        DicePool())

        if (dices.isEmpty) {
            self.rolls = []
        } else {
            self.rolls = dices.map({
                let die = $0
                let roll = die.roll()
                if (roll < die.threshold) {
                    results.failures += 1
                    if (roll == die.min) {
                        results.criticalFailures += 1
                    }
                } else {
                    results.successes += 1
                    if (roll == die.max) {
                        results.criticalSuccesses += 1
                    }
                }
                return DicePool(roll)
            })
        }

        (self.successes, self.failures, self.criticalSuccesses, self.criticalFailures) = results
    }

    func isGlitch() -> Bool {
        return criticalFailures >= DicePool(rolls.count / 2)
    }

    func isCriticalGlitch() -> Bool {
        return successes == 0 && isGlitch()
    }

    fileprivate init(rolls: [DicePool] = [], successes: DicePool = 0, failures: DicePool = 0, criticalSuccesses: DicePool = 0,
                     criticalFailures: DicePool = 0) {
        self.rolls = rolls
        self.successes = successes
        self.failures = failures
        self.criticalSuccesses = criticalSuccesses
        self.criticalFailures = criticalFailures
    }


    static func +(left: RollResult, right: RollResult) -> RollResult {
        return RollResult(rolls: left.rolls + right.rolls, successes: left.successes + right.successes, failures: left.failures + right.failures, criticalSuccesses: left.criticalSuccesses + right.criticalSuccesses, criticalFailures: left.criticalFailures + right.criticalFailures)
    }

    func description() -> String {
        return "rolls: \(rolls) S: \(successes) / F: \(failures) / CS: \(criticalSuccesses) / CF: \(criticalFailures)"
    }
}
