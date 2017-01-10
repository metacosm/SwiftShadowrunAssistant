//
//  Engine.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

class Engine {
    static let attributeInfosAndOrder = [AttributeInfo.body, .agility, .reaction, .strength, .willpower, .logic, .intuition,
                                         .charisma, .edge]

    static let d6 = Die(min: 1, max: 6, threshold: 5)

    private var dieType: Die = d6

    private var skills: SkillRegistry!
    private var characters: CharacterRegistry!

    init() {
        self.skills = SkillRegistry(self)
        self.characters = CharacterRegistry(self)
    }


    func setDie(type: Die) {
        self.dieType = type
    }

    func attributeNames() -> [String] {
        return Engine.attributeInfosAndOrder.map {
            $0.name()
        }
    }

    func attributeInfos() -> [AttributeInfo] {
        return Engine.attributeInfosAndOrder
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

    func rollInitiative(character: Character, usingEdge: Bool) -> Int {
        return character.dicePoolSize(for: AttributeInfo.initiative)
                + roll(AttributeInfo.initiative, for: character, usingEdge: usingEdge).successes
    }

    func roll(_ info: CharacteristicInfo, for character: Character, usingEdge: Bool = false) -> RollResult {
        let baseDicePool = character.dicePoolSize(for: info)
        let dicePool = baseDicePool + (usingEdge ? character.dicePoolSize(for: AttributeInfo.edge) : 0)

        let result = roll(dices: [Die](repeating: dieType, count: dicePool), usingEdge: usingEdge)

        return result
    }

    func roll(dices: [Die], usingEdge: Bool) -> RollResult {
        let results = RollResult(dices: dices)

        let criticalSuccesses = results.criticalSuccesses
        if (!dices.isEmpty && usingEdge && criticalSuccesses > 0) {
            let newDices = [Die](repeating: dieType, count: criticalSuccesses)
            let r = results + roll(dices: newDices, usingEdge: true)
            return r
        }

        return results
    }

    enum EngineError: Error {
        case invalidAttribute
    }

}
