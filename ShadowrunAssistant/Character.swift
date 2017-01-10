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
    private var modifiers: [CharacteristicInfo: [Modifier]]

    init(name: String) {
        self._name = name
        self.baseCharacteristicValues = [CharacteristicInfo: Int]()
        self.modifiers = [CharacteristicInfo: [Modifier]]()

        // make sure we have values for base attributes
        for attrInfo in AttributeInfo.baseAttributes() {
            setAttribute(attrInfo, at: 1)
        }
    }

    func attribute(_ info: AttributeInfo) -> Attribute {
        return Attribute(info: info, for: self)

    }

    func skill(_ info: SkillInfo) -> Skill? {
        return Skill(info: info, for: self)
    }

    private func setCharacteristic(_ info: CharacteristicInfo, at baseValue: Int) {
        // todo: check value is within acceptable range
        baseCharacteristicValues[info] = baseValue
    }

    func setAttribute(_ info: AttributeInfo, at baseValue: Int) {
        setCharacteristic(info, at: baseValue)
    }


    func setSkill(_ info: SkillInfo, at baseValue: Int) {
        setCharacteristic(info, at: baseValue)
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

    func modifiedValue(for info: CharacteristicInfo?) -> Int {
        guard let info = info else {
            return 0
        }

        let base = baseValue(for: info)

        guard let modifiers = modifiers[info.primaryCharacteristic()] else {
            return base
        }

        let result: Int = modifiers.reduce(base, { result, modifier in result + modifier.modifier })
        return result
    }

    func baseValue(for info: CharacteristicInfo?) -> Int {
        guard let info = info else {
            return 0
        }

        let primary = info.primaryCharacteristic()
        guard let value = baseCharacteristicValues[primary] else {
            return 0
        }

        return value
    }

    func modifiers(for info: CharacteristicInfo?) -> [Modifier]? {
        guard let info = info else {
            return nil
        }

        return modifiers[info]
    }

    func setModifier(for info: CharacteristicInfo?, at modifier: Modifier) {
        guard let info = info else {
            return
        }

        if var currentModifiers = modifiers[info] {
            currentModifiers.append(modifier)
            modifiers[info] = currentModifiers
        } else {
            modifiers[info] = [modifier]
        }
    }
}
