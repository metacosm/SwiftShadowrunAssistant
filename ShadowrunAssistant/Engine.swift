//
//  Engine.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

class Engine {
    static let attributeNamesAndOrder = ["Body", "Agility", "Reaction", "Strength", "Willpower", "Logic", "Intuition", "Charisma", "Edge"]
    static let d6 = Die(min: 1, max: 6, threshold: 5)
    
    private var dieType: Die = d6
    
    func setDie(type: Die) {
        self.dieType = type
    }

    func attributeNames() -> [String] {
        return Engine.attributeNamesAndOrder
    }

    func createCharacter() -> Character {
        var builder = CharacterBuilder()
        
        Engine.attributeNamesAndOrder.forEach {
            builder.attribute(named: $0, with: 3)
        }
        
        return builder.build()
    }
    
    func rollInitiative(character: Character, usingEdge: Bool) throws -> Int {
        let reaction = try character.attribute(named: "Reaction")
        let intuition = try character.attribute(named: "Intuition")
        
        let initiativeDice = reaction.modifiedValue + intuition.modifiedValue
        let result = roll(dices: [Die](repeating: dieType, count: initiativeDice), usingEdge: usingEdge)
        
        return initiativeDice + result.successes
    }

    func roll(dices: [Die], usingEdge: Bool) -> RollResult {
        let results = RollResult(dices: dices)
        
        if(usingEdge) {
            return results + roll(dices: [Die](repeating: dieType, count: results.criticalSuccesses), usingEdge: true)
        }
        
        return results
    }
    
    enum EngineError: Error {
        case invalidAttribute
    }
}
