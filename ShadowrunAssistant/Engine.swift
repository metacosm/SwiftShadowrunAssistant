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
}
