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
    static let essence = AttributeInfo(name: "Essence", description: "essence", decreasing: true, group: .special)
    static let magic = AttributeInfo(name: "Magic", description: "magic", decreasing: false, group: .magic)
    static let resonance = AttributeInfo(name: "Resonance", description: "resonance", decreasing: false,
            group: .matrix)

    // initiatives
    static let initiative = AttributeInfo(name: "Initiative", description: "initiative", primary: Engine.reaction,
            secondary: Engine.intuition)
    static let astralInitiative = AttributeInfo(name: "Astral initiative", description: "astral initiative",
            primary: Engine.intuition, secondary: Engine.intuition)
    static let augmentedInitiative = AttributeInfo(name: "Matrix initiative", description: "matrix initiative",
            primary: Engine.reaction, secondary: Engine.intuition)
    static let coldSimVRInitiative = AttributeInfo(name: "Cold sim VR initiative", description: "cold sim VR " +
            "initiative", primary: Engine.response, secondary: Engine.intuition)
    static let hotSimVRInitiative = AttributeInfo(name: "Hot sim VR initiative", description: "hot sim VR " +
            "initiative", primary: Engine.response, secondary: Engine.intuition)
    static let initiativePasses = AttributeInfo(name: "Initiative Passes", description: "initiative passes")

    // derived
    static let composure = AttributeInfo(name: "Composure", description: "composure", primary: Engine.willpower,
            secondary: Engine.charisma)
    static let judgeIntentions = AttributeInfo(name: "Judge intentions", description: "judge intentions",
            primary: Engine.intuition, secondary: Engine.charisma)
    static let memory = AttributeInfo(name: "Memory", description: "memory", primary: Engine.logic,
            secondary: Engine.willpower)
    static let liftCarry = AttributeInfo(name: "Lift and Carry", description: "lift and carry",
            primary: Engine.strength, secondary: Engine.body)

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
    private var attributes: [String: AttributeInfo]


    init() {
        baseAttributes = [Engine.agility, Engine.body, Engine.reaction, Engine.strength, Engine.charisma,
                          Engine.intuition, Engine.logic, Engine.willpower]
        derivedAttributes = [Engine.composure, Engine.judgeIntentions, Engine.liftCarry, Engine.memory]
        specialAttributes = [Engine.edge, Engine.essence, Engine.magic, Engine.resonance, Engine.initiative]

        attributes = [String: AttributeInfo](minimumCapacity: baseAttributes.count + derivedAttributes.count +
                specialAttributes.count)

        func putInAttributes(coll: [AttributeInfo]) {
            for attr in coll {
                attributes[attr.name()] = attr
            }
        }

        putInAttributes(coll: baseAttributes)
        putInAttributes(coll: derivedAttributes)
        putInAttributes(coll: specialAttributes)


        skills = SkillRegistry(self)
        characters = CharacterRegistry(self)
    }


    func setDie(type: Die) {
        self.dieType = type
    }

    func attributeInfos() -> [AttributeInfo] {
        return attributes.map { _, info in
            return info
        }
    }

    func attributeInfo(named: String) -> AttributeInfo? {
        return attributes[named]
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

    func rollInitiative(character: Character, usingEdge: Bool) -> DicePool {
        return character.dicePoolSize(for: Engine.initiative)
                + roll(Engine.initiative, for: character, usingEdge: usingEdge).successes
    }

    func roll(_ info: CharacteristicInfo, for character: Character, usingEdge: Bool = false) -> RollResult {
        let baseDicePool = character.dicePoolSize(for: info)
        let dicePool = baseDicePool + (usingEdge ? character.dicePoolSize(for: Engine.edge) : 0)

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
