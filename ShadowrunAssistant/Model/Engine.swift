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
//   private var sessions: [Date: GameSession]
   private var stats: [CharacteristicInfo: CharacteristicStats] = [:]


   init() {
      baseAttributes = [Engine.agility, Engine.body, Engine.reaction, Engine.strength, Engine.charisma,
                        Engine.intuition, Engine.logic, Engine.willpower]
      derivedAttributes = [Engine.composure, Engine.judgeIntentions, Engine.liftCarry, Engine.memory]
      specialMandatoryAttributes = [Engine.edge, Engine.essence, Engine.initiative]

      skills = SkillRegistry(self)
      characters = CharacterRegistry(self)

      let importer = SkillsImporter()
      importer.importSkills(from: SkillsImporter.chinaGreenElvisReference, registry: skills)
      /*let session = GameSession()
      sessions = [session.date : session]*/
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
