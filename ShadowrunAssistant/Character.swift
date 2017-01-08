//
//  Character.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

class Character {
    private var characteristics: [CharacteristicInfo: Characteristic]
    private var modifiers: [String: [Modifier]]

    required init(attributes: [Attribute], skills: [Skill], modifiedBy: [String: [Modifier]]) {
        characteristics = [CharacteristicInfo: Characteristic](minimumCapacity: attributes.count + skills.count)
        self.modifiers = [String: [Modifier]](minimumCapacity: modifiedBy.count)

        attributes.forEach {
            characteristics[$0.info()] = $0
        }

        skills.forEach {
            characteristics[$0.info()] = $0
        }

        for (name, modifiers) in modifiedBy {
            self.modifiers[name] = modifiers
        }
    }

    private func characteristic(_ info: CharacteristicInfo) -> Characteristic? {
        let charac = characteristics[info]
        guard let characteristic = charac else {
            return nil
        }

        if (info.type() != characteristic.info().type()) {
            return nil
        } else {
            guard let modifiersForCharac = modifiers[info.name()] else {
                return characteristic
            }

            switch info.type() {
            case .attribute:
                return Attribute(attribute: characteristic as! Attribute, modifiers: modifiersForCharac)
            case .skill:
                return Skill(skill: characteristic as! Skill, modifiers: modifiersForCharac)
            default:
                return nil
            }
        }
    }

    func attribute(_ info: AttributeInfo) -> Attribute {
        return characteristic(info) as! Attribute
        
    }

    func skill(_ info: SkillInfo) -> Skill? {
        guard let skill = characteristic(info) else {
            return nil
        }

        return skill as? Skill
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

    @discardableResult func skill(_ named: SkillInfo, with value: Int = 1) -> CharacterBuilder {
        skills.append(Skill(info: named, value: value, modifiers: []))
        return self
    }

    func build() -> Character {
        // todo: check that character actually has values for all defined attributes

        return Character(attributes: attributes, skills: skills, modifiedBy: modifiers)
    }

}
