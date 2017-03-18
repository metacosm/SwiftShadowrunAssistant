//
//  Engine.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

class Engine {
   static let d6 = Die(min: 1, max: 6, threshold: 5)
   public static let defaultAttributeRange = CharacteristicRange(min: 1, max: 6)
   public static let defaultSkillRange = CharacteristicRange(min: 1, max: 6)


   // physical
   static let agility = SimpleAttributeInfo(name: "Agility", description: "description")
   static let body = SimpleAttributeInfo(name: "Body", description: "Body")
   static let reaction = SimpleAttributeInfo(name: "Reaction", description: "description")
   static let strength = SimpleAttributeInfo(name: "Strength", description: "description")

   // mental
   static let charisma = SimpleAttributeInfo(name: "Charisma", description: "description", group: .mental)
   static let intuition = SimpleAttributeInfo(name: "Intuition", description: "description", group: .mental)
   static let logic = SimpleAttributeInfo(name: "Logic", description: "description", group: .mental)
   static let willpower = SimpleAttributeInfo(name: "Willpower", description: "description", group: .mental)

   // special
   static let edge = SimpleAttributeInfo(name: "Edge", description: "description", group: .special)
   static let essence = SimpleAttributeInfo(name: "Essence", description: "essence", group: .special, initialValue: 6)
   static let magic = SimpleAttributeInfo(name: "Magic", description: "magic", group: .magic, initialValue: 0)
   static let resonance = SimpleAttributeInfo(name: "Resonance", description: "resonance", group: .matrix,
         initialValue: 0)

   // initiatives
   static let initiative = DerivedAttributeInfo(name: "Initiative", description: "initiative", first: Engine.reaction,
         second: Engine.intuition)
   static let astralInitiative = DerivedAttributeInfo(name: "Astral initiative", description: "astral initiative",
         first: Engine.intuition, second: Engine.intuition)
   static let augmentedInitiative = DerivedAttributeInfo(name: "Matrix initiative", description: "matrix initiative",
         first: Engine.reaction, second: Engine.intuition)
   static let coldSimVRInitiative = DerivedAttributeInfo(name: "Cold sim VR initiative", description: "cold sim VR " +
         "initiative", first: Engine.response, second: Engine.intuition)
   static let hotSimVRInitiative = DerivedAttributeInfo(name: "Hot sim VR initiative", description: "hot sim VR " +
         "initiative", first: Engine.response, second: Engine.intuition)
   static let initiativePasses = AttributeInfo(name: "Initiative Passes", description: "initiative passes")

   // derived
   static let composure = DerivedAttributeInfo(name: "Composure", description: "composure", first: Engine.willpower,
         second: Engine.charisma)
   static let judgeIntentions = DerivedAttributeInfo(name: "Judge intentions", description: "judge intentions",
         first: Engine.intuition, second: Engine.charisma)
   static let memory = DerivedAttributeInfo(name: "Memory", description: "memory", first: Engine.logic,
         second: Engine.willpower)
   static let liftCarry = DerivedAttributeInfo(name: "Lift and Carry", description: "lift and carry",
         first: Engine.strength, second: Engine.body)

   // matrix
   static let response = SimpleAttributeInfo(name: "Response", description: "response", group: .matrix)
   static let signal = SimpleAttributeInfo(name: "Signal", description: "signal", group: .matrix)
   static let firewall = SimpleAttributeInfo(name: "Firewall", description: "firewall", group: .matrix)
   static let system = SimpleAttributeInfo(name: "System", description: "system", group: .matrix)

   private var dieType: Die = d6

   private var skills: SkillRegistry!
   private var characters: CharacterRegistry!
   private let baseAttributes: [AttributeInfo]
   private let derivedAttributes: [AttributeInfo]
   private let specialMandatoryAttributes: [AttributeInfo]
   private var stats: [CharacteristicInfo: CharacteristicStats] = [:]


   init() {
      baseAttributes = [Engine.agility, Engine.body, Engine.reaction, Engine.strength, Engine.charisma,
                        Engine.intuition, Engine.logic, Engine.willpower]
      derivedAttributes = [Engine.composure, Engine.judgeIntentions, Engine.liftCarry, Engine.memory]
      specialMandatoryAttributes = [Engine.edge, Engine.essence, Engine.initiative]

      skills = SkillRegistry(self)
      characters = CharacterRegistry(self)
   }


   func setDie(type: Die) {
      self.dieType = type
   }

   func attributeInfos() -> [AttributeInfo] {
      return baseAttributes + derivedAttributes + specialMandatoryAttributes
   }

   func attributeInfo(named: String) -> AttributeInfo? {
      return attributeInfos().filter {
         $0.name == named
      }.first
   }

   func skillInfo(named: String) -> SkillInfo? {
      return skills.skill(named: named)
   }

   func skillRegistry() -> SkillRegistry {
      return skills
   }

   func characterRegistry() -> CharacterRegistry {
      return characters
   }

   func rollInitiative(for character: Shadowrunner, usingEdge: Bool) -> DicePool {
      let initiative = character.characteristic(Engine.initiative)
      return initiative.dicePool + roll(initiative, usingEdge: usingEdge).successes
   }

   func roll(_ characteristic: Characteristic, usingEdge: Bool = false) -> RollResult {
      let baseDicePool = characteristic.dicePool
      let dicePool = baseDicePool + (usingEdge ? characteristic.character.dicePool(for: Engine.edge) : 0)

      let result = roll(dices: [Die](repeating: dieType, count: Int(dicePool)), usingEdge: usingEdge)

      // perform stats
      if var stats = stats[characteristic.info] {
         stats.add(result: result)
         self.stats[characteristic.info] = stats
      } else {
         stats[characteristic.info] = CharacteristicStats(result: result)
      }

      return result
   }

   func roll(dices: [Die], usingEdge: Bool) -> RollResult {
      let results = RollResult(dices: dices)

      let criticalSuccesses = results.criticalSuccesses
      if (!dices.isEmpty && usingEdge && criticalSuccesses > 0) {
         let newDices = [Die](repeating: dieType, count: Int(criticalSuccesses))
         let r = results + roll(dices: newDices, usingEdge: true)
         return r
      }

      return results
   }

   func stats(for characteristic: Characteristic) -> CharacteristicStats? {
      return stats[characteristic.info]
   }

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
