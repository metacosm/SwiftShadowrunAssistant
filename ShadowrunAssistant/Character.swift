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
    private var baseCharacteristicValues: [CharacteristicInfo: Int]
    private var modifiers: [String: [Modifier]]

    required init(name: String, attributes: [Attribute], skills: [Skill], modifiedBy: [String: [Modifier]]) {
        self._name = name
        baseCharacteristicValues = [CharacteristicInfo: Int](minimumCapacity: attributes.count + skills.count)
        self.modifiers = [String: [Modifier]](minimumCapacity: modifiedBy.count)

        attributes.forEach {
            baseCharacteristicValues[$0.info()] = $0.value()
        }

        skills.forEach {
            baseCharacteristicValues[$0.info()] = $0.value()
        }

        for (name, modifiers) in modifiedBy {
            self.modifiers[name] = modifiers
        }
    }

    private func characteristic(_ info: CharacteristicInfo) -> Characteristic? {
        let charac = baseCharacteristicValues[info]
        guard let characteristic = charac else {
            return nil
        }

        switch info.type() {
        case .attribute:
            return Attribute(info: info as! AttributeInfo, value: characteristic, modifiers: modifiers[info.name()])
        case .skill:
            return Skill(info: info as! SkillInfo, value: characteristic, modifiers: modifiers[info.name()])
        default:
            return nil
        }
    }

    func attribute(_ info: AttributeInfo) -> Attribute {
        return characteristic(info) as! Attribute

    }

    /*func setAttribute(_ info: AttributeInfo, at value: Int) -> Attribute {

    }
*/
    func skill(_ info: SkillInfo) -> Skill? {
        guard let skill = characteristic(info) else {
            return nil
        }

        return skill as? Skill
    }

    func name() -> String {
        return _name
    }

    func dicePoolSize(for info: CharacteristicInfo?) -> Int {
        guard let info = info else {
            return 0
        }

        guard let linked = info.linkedCharacteristic() else {
            return modifiedValue(for: info)
        }

        return dicePoolSize(for: linked) + modifiedValue(for: info)
    }

    func modifiedValue(for info: CharacteristicInfo) -> Int {
        let primary = info.primaryCharacteristic()
        guard let value = baseCharacteristicValues[primary] else {
            return 0
        }

        if let modifiers = modifiers[primary.name()] {
            let result: Int = modifiers.reduce(value,
                    { result, modifier in result + modifier.modifier })
            return result
        } else {
            return value
        }
    }
}
