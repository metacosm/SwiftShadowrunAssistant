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
        return Engine.attributeInfosAndOrder.map{ $0.name() }
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
        let reaction = character.attribute(.reaction)
        let intuition = character.attribute(.intuition)

        let initiativeDice = reaction.dicePoolSize() + intuition.dicePoolSize()
        let diceNumber = initiativeDice + (usingEdge ? character.attribute(.edge).dicePoolSize() : 0)
        let result = roll(dices: [Die](repeating: dieType, count: diceNumber), usingEdge: usingEdge)
        
        return initiativeDice + result.successes
    }

    func roll(_ characteristic: Characteristic?, for character: Character, usingEgde: Bool = false) -> Int {
        guard let characteristic = characteristic else {
            return 0
        }
        return 0
    }

    func roll(dices: [Die], usingEdge: Bool) -> RollResult {
        let results = RollResult(dices: dices)

        let criticalSuccesses = results.criticalSuccesses
        if(!dices.isEmpty && usingEdge && criticalSuccesses > 0) {
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
