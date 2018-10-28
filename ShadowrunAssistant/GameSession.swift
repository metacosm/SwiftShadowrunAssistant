//
// Created by Christophe Laprun on 24/03/2017.
// Copyright (c) 2017 Christophe Laprun. All rights reserved.
//

import Foundation

struct GameSession {
    private var stats: [CharacteristicInfo: CharacteristicStats] = [:]
    let date: Date = Date()
}

struct CharacteristicStats: CustomStringConvertible {
    private var _successes: [DicePool] = []
    private var _failures: [DicePool] = []
    private var _criticalSuccesses: [DicePool] = []
    private var _criticalFailures: [DicePool] = []
    private var _glitches: Int = 0
    private var _criticalGlitches: Int = 0
    private var _rolls: Int = 0

    init(result: RollResult) {
        add(result: result)
    }

    mutating func add(result: RollResult) {
        _successes.append(result.successes)
        _failures.append(result.failures)
        _criticalSuccesses.append(result.criticalSuccesses)
        _criticalFailures.append(result.criticalFailures)
        _glitches += result.isGlitch() ? 1 : 0
        _criticalGlitches += result.isCriticalGlitch() ? 1 : 0
        _rolls += 1
    }

    var successes: [DicePool] {
        return _successes
    }

    var failures: [DicePool] {
        return _failures
    }

    var criticalSuccesses: [DicePool] {
        return _criticalSuccesses
    }

    var criticalFailures: [DicePool] {
        return _criticalFailures
    }

    var glitches: Int {
        return _glitches
    }

    var criticalGlitches: Int {
        return _criticalGlitches
    }

    var rolls: Int {
        return _rolls
    }

    func mean(of values: [DicePool]) -> Float {
        if (rolls == 1) {
            return Float(values.first!)
        }

        let sum = Float(values.reduce(0, { sum, next in sum + next }))
        return sum / Float(rolls)
    }

    func median(of values: [DicePool]) -> Float {
        let sorted = values.sorted()
        if sorted.count.isOdd {
            return Float(sorted[Int(sorted.count / 2)])
        } else {
            let middle = Int(sorted.count / 2)
            return Float(sorted[middle - 1] + sorted[middle]) / 2
        }
    }

    func mode(of values: [DicePool]) -> [DicePool]? {
        var buckets: [DicePool: Int] = [:]
        for value in values {
            if let cardinalityForValue = buckets[value] {
                buckets[value] = cardinalityForValue + 1
            } else {
                buckets[value] = 1
            }
        }

        let sorted = buckets.sorted(by: { $0.value < $1.value })
        let maxCardinality = sorted.last?.value
        let mode = sorted.filter {
            $0.value == maxCardinality
        }.map {
            $0.key
        }

        return mode.isEmpty ? nil : mode
    }


    struct StandardDeviationData: CustomStringConvertible {
        let mean: Float
        let stdDev: Float
        private let format = ".3"

        init(_ mean: Float, _ stdDev: Float) {
            self.mean = mean
            self.stdDev = stdDev
        }

        public var description: String {
            return "mean: \(mean.format(format)) (σ: \(stdDev.format(format)))"
        }
    }

    func standardDeviation(of values: [DicePool]) -> StandardDeviationData {
        if (rolls == 1) {
            return StandardDeviationData(Float(values.first!), 0)
        }

        let mean = self.mean(of: values)
        let sumOfDifferencesToMean = values.map {
            Float($0) - mean
        }.map {
            $0 * $0
        }.reduce(0, { sum, next in sum + next })
        let variance = sumOfDifferencesToMean / Float(rolls - 1)

        return StandardDeviationData(mean, sqrt(variance))
    }


    public var description: String {
        let format = ".2"
        let successStats = standardDeviation(of: successes)
        let successMean = successStats.mean.format(format)
        let failureMean = mean(of: failures).format(format)
        let stdDev = successStats.stdDev.format(format) // failures and successes have the same std dev since they are dependent


        return "Successes: ~\(successMean) / Failures: ~\(failureMean) (σ: \(stdDev)) on \(rolls) rolls"
    }
}

extension Int {
    var isOdd: Bool {
        return self % 2 != 0
    }
}

extension Float {
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
