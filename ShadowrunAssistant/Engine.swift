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

   // physical
   static let agility = AttributeInfo(name: "Agility", description: "description")
   static let body = AttributeInfo(name: "Body", description: "Body")
   static let reaction = AttributeInfo(name: "Reaction", description: "description")
   static let strength = AttributeInfo(name: "Strength", description: "description")

   // mental
   static let charisma = AttributeInfo(name: "Charisma", description: "description", group: .mental)
   static let intuition = AttributeInfo(name: "Intuition", description: "description", group: .mental)
   static let logic = AttributeInfo(name: "Logic", description: "description", group: .mental)
   static let willpower = AttributeInfo(name: "Willpower", description: "description", group: .mental)

   // special
   static let edge = AttributeInfo(name: "Edge", description: "description", group: .special)
   static let essence = SimpleAttributeInfo(name: "Essence", description: "essence", group: .special, initialValue: 6)
   static let magic = AttributeInfo(name: "Magic", description: "magic", group: .magic)
   static let resonance = AttributeInfo(name: "Resonance", description: "resonance", group: .matrix)

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
   static let response = AttributeInfo(name: "Response", description: "response", group: .matrix)
   static let signal = AttributeInfo(name: "Signal", description: "signal", group: .matrix)
   static let firewall = AttributeInfo(name: "Firewall", description: "firewall", group: .matrix)
   static let system = AttributeInfo(name: "System", description: "system", group: .matrix)

   private var dieType: Die = d6

   private var skills: SkillRegistry!
   private var characters: CharacterRegistry!
   private let baseAttributes: [AttributeInfo]
   private let derivedAttributes: [AttributeInfo]
   private let specialAttributes: [AttributeInfo]
   private var stats: [CharacteristicInfo: CharacteristicStats] = [:]


   init() {
      baseAttributes = [Engine.agility, Engine.body, Engine.reaction, Engine.strength, Engine.charisma,
                        Engine.intuition, Engine.logic, Engine.willpower]
      derivedAttributes = [Engine.composure, Engine.judgeIntentions, Engine.liftCarry, Engine.memory]
      specialAttributes = [Engine.edge, Engine.essence, Engine.magic, Engine.resonance, Engine.initiative]

      skills = SkillRegistry(self)
      characters = CharacterRegistry(self)
   }


   func setDie(type: Die) {
      self.dieType = type
   }

   func attributeInfos() -> [AttributeInfo] {
      return baseAttributes + derivedAttributes + specialAttributes
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

   enum EngineError: Error {
      case invalidAttribute
      case invalidCharacteristicGroup
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

   var description: String {
      return "Mean successes: \(mean(of: successes)) / Mean failures: \(mean(of: failures))"
   }
}

extension Int {
   var isOdd: Bool {
      return self % 2 != 0
   }
}
