//
//  Character.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

class Character {
    private var _realName: String?
    private let _name: String 
    private var characteristics: [CharacteristicInfo: Characteristic]
    private var modifiers: [String: [Modifier]]

    required init(name: String, attributes: [Attribute], skills: [Skill], modifiedBy: [String: [Modifier]]) {
        self._name = name
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

    func name() -> String {
        return _name
    }
}
