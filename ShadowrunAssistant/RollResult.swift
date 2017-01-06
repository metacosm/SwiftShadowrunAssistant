//
//  RollResult.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 04/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

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
                }
            } else {
                results.successes += 1
                if (roll == die.max) {
                    results.criticalSuccesses += 1
                }
            }
            return Int(roll)
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

    static func +(left: RollResult, right: RollResult) -> RollResult {
        return RollResult(rolls: left.rolls + right.rolls, successes: left.successes + right.successes, failures: left.failures + right.failures, criticalSuccesses: left.criticalSuccesses + right.criticalSuccesses, criticalFailures: left.criticalFailures + right.criticalFailures)
    }

}
