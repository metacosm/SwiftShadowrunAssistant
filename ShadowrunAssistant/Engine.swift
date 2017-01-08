//
//  Engine.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

enum AttributeInfo: String, Describable {
    internal func name() -> String {
        return self.rawValue
    }

    case body = "Body",
         agility = "Agility",
         reaction = "Reaction",
         strength = "Strength",
         willpower = "Willpower",
         logic = "Logic",
         intuition = "Intuition",
         charisma = "Charisma",
         edge = "Edge"

    func description() -> String {
        return name() // todo
    }
}

protocol Describable {
    func description() -> String
    func name() -> String
}

struct SkillInfo: Describable, Hashable {
    private let _name: String
    private let _description: String

    init(name: String, description: String) {
        _name = name
        _description = description
    }

    internal func name() -> String {
        return _name
    }

    internal func description() -> String {
        return _description
    }

    public var hashValue: Int {
        return _name.hashValue
    }

    public static func ==(lhs: SkillInfo, rhs: SkillInfo) -> Bool {
        return lhs._name == rhs._name
    }
}

class Engine {
    static let attributeInfosAndOrder = [AttributeInfo.body, .agility, .reaction, .strength, .willpower, .logic, .intuition,
                                         .charisma, .edge]

    static let d6 = Die(min: 1, max: 6, threshold: 5)
    
    private var dieType: Die = d6
    
    func setDie(type: Die) {
        self.dieType = type
    }

    func attributeNames() -> [String] {
        return Engine.attributeInfosAndOrder.map{ $0.name() }
    }

    func attributeInfos() -> [AttributeInfo] {
        return Engine.attributeInfosAndOrder
    }
    
    func createCharacter() -> Character {
        let builder = CharacterBuilder()

        Engine.attributeInfosAndOrder.forEach {
            let name = $0
            builder.attribute(name, with: 3)
        }

        return builder.build()
    }
    
    func rollInitiative(character: Character, usingEdge: Bool) throws -> Int {
        let reaction = character.attribute(.reaction)
        let intuition = character.attribute(.intuition)

        let initiativeDice = reaction.rollingValue + intuition.rollingValue
        let diceNumber = initiativeDice + (usingEdge ? character.attribute(.edge).rollingValue : 0)
        let result = roll(dices: [Die](repeating: dieType, count: diceNumber), usingEdge: usingEdge)
        
        return initiativeDice + result.successes
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
