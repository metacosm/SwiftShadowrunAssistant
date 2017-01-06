//
//  Character.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

class Character {
    private let attributes: [AttributeInfo: Attribute]
    private let modifiers: [String: [Modifier]]
    private let skills: [SkillInfo: Skill]

    required init(attributes: [Attribute], skills: [Skill], modifiedBy: [String: [Modifier]]) {
        var attrDict: [AttributeInfo: Attribute] = [AttributeInfo: Attribute](minimumCapacity: attributes.count)
        var skillDict: [SkillInfo: Skill] = [SkillInfo: Skill](minimumCapacity: skills.count)
        var modDict = [String: [Modifier]](minimumCapacity: modifiedBy.count)

        attributes.forEach {
            let info = AttributeInfo(rawValue: $0.name())!
            attrDict[info] = $0
        }

        skills.forEach {
            // todo: skill registry
            let info = SkillInfo(name: $0.name(), description: "")
            skillDict[info] = $0
        }

        for (name, modifiers) in modifiedBy {
            modDict[name] = modifiers
        }

        self.attributes = attrDict
        self.modifiers = modDict
        self.skills = skillDict
    }

    func attribute(_ info: AttributeInfo) -> Attribute {
        let attribute = attributes[info]!
        guard let modifiersForAttr = modifiers[info.name()] else {
            return attribute
        }

        return Attribute(attribute: attribute, modifiers: modifiersForAttr)
    }

    func skill(_ info: SkillInfo) -> Skill {
        let skill = skills[info]!
        guard let modifiersForSkill = modifiers[info.name()] else {
            return skill
        }

        return Skill(skill: skill, modifiers: modifiersForSkill)
    }
}

class CharacterBuilder {
    private var attributes: [Attribute] = [Attribute]()
    private var modifiers: [String: [Modifier]] = [String: [Modifier]]()
    private var skills: [Skill] = [Skill]()

    @discardableResult func attribute(_ named: AttributeInfo, with value: Int = 3) -> CharacterBuilder {
        attributes.append(Attribute(info: named, value: value))
        return self
    }

    @discardableResult func modifier(for name: String, value: Int) -> CharacterBuilder {
        let modifier = Modifier(value: value)
        if var currentModifiers = modifiers[name] {
            currentModifiers.append(modifier)
        } else {
            modifiers[name] = [modifier]
        }
        return self
    }

    @discardableResult func skill(_ named: SkillInfo, with value: Int = 1, linkedTo: AttributeInfo) -> CharacterBuilder {
        skills.append(Skill(info: named, value: value, modifiers: [], with: linkedTo))
        return self
    }

    func build() -> Character {
        // todo: check that character actually has values for all defined attributes

        return Character(attributes: attributes, skills: skills, modifiedBy: modifiers)
    }

}
