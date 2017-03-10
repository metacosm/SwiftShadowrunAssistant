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

   func rollInitiative(character: Shadowrunner, usingEdge: Bool) -> DicePool {
      return character.attribute(Engine.initiative).dicePool
                + roll(Engine.initiative, for: character, usingEdge: usingEdge).successes
    }

   func roll(_ info: CharacteristicInfo, for character: Shadowrunner, usingEdge: Bool = false) -> RollResult {
      let baseDicePool = character.dicePool(for: info)
      let dicePool = baseDicePool + (usingEdge ? character.dicePool(for: Engine.edge) : 0)

        let result = roll(dices: [Die](repeating: dieType, count: Int(dicePool)), usingEdge: usingEdge)

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

}
