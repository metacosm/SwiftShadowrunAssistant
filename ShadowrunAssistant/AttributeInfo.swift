//
//  AttributeInfo.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class AttributeInfo: CharacteristicInfo {
    static let body = AttributeInfo(name: "Body", description: "Body")
    static let agility = AttributeInfo(name: "Agility", description: "description")
    static let reaction = AttributeInfo(name: "Reaction", description: "description")
    static let strength = AttributeInfo(name: "Strength", description: "description")
    static let willpower = AttributeInfo(name: "Willpower", description: "description")
    static let logic = AttributeInfo(name: "Logic", description: "description")
    static let intuition = AttributeInfo(name: "Intuition", description: "description")
    static let charisma = AttributeInfo(name: "Charisma", description: "description")
    static let edge = AttributeInfo(name: "Edge", description: "description")
    static let initiative = AttributeInfo(name: "Initiative", description: "initiative", primary: .reaction,
            secondary: .intuition)

    var primary: AttributeInfo!
    var secondary: AttributeInfo!

    override private init(name: String, description: String) {
        super.init(name: name, description: description)
    }

    convenience private init(name: String, description: String, primary: AttributeInfo, secondary: AttributeInfo) {
        self.init(name: name, description: description)

        self.primary = primary
        self.secondary = secondary

    }

    override func primaryCharacteristic() -> CharacteristicInfo {
        return primary != nil ? primary : self
    }

    override func linkedCharacteristic() -> CharacteristicInfo? {
        return secondary
    }

    override func type() -> CharacteristicType {
        return .attribute
    }
}
