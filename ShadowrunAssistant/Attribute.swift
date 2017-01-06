//
//  Attribute.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 14/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

struct Modifier {
    init(value: Int) {
        self.init(name: "modifier", value: value)
    }

    init(name: String, value: Int) {
        self.init(name: name, value: value, description: nil)
    }

    init(name: String, value: Int, description: String?) {
        self.name = name
        self.modifier = value
        self.description = description
    }

    let name: String
    var modifier: Int
    let description: String?
    var modifierAsString: String {
        get {
            return modifier > 0 ? "+\(modifier)" : "\(modifier)"
        }
    }
}

class Attribute: Characteristic<AttributeInfo> {
    init(info: AttributeInfo, value: Int) {
        super.init(info: info, value: value, modifiers: nil, with: nil)
    }

    init(attribute: Attribute, modifiers: [Modifier]) {
        super.init(info: attribute.info(), value: attribute.value(), modifiers: modifiers, with: nil)
    }
}

class Skill: Characteristic<SkillInfo> {
    init(info: SkillInfo, value: Int, modifiers: [Modifier], with: AttributeInfo) {
        super.init(info: info, value: value, modifiers: modifiers, with: with)
    }

    init(skill: Skill, modifiers: [Modifier]) {
        super.init(info: skill.info(), value: skill.value(), modifiers: modifiers, with: skill.linkedAttribute())
    }
}


