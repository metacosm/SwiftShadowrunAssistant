//
//  Character.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

class Character {
    private let registry: CharacterRegistry
    private var _realName: String?
    private let _name: String
    private var baseCharacteristicValues: [CharacteristicInfo: DicePool]
    private var modifiers: [CharacteristicInfo: [Modifier]]
//    private var characteristics: [CharacteristicInfo: Characteristic]

    init(name: String, registry: CharacterRegistry) {
        self.registry = registry

        self._name = name
        self.baseCharacteristicValues = [CharacteristicInfo: DicePool]()
        self.modifiers = [CharacteristicInfo: [Modifier]]()
//        self.characteristics = [CharacteristicInfo: Characteristic]()

        // make sure we have values for all known attributes
        for attrInfo in registry.engine.attributeInfos() {
            if !attrInfo.isMandatory() || attrInfo.isDerived() {
                setAttribute(attrInfo, at: 0)
            } else if attrInfo.isDecreasing() {
                setAttribute(attrInfo, at: 6) // todo: remove hardcoded value
            } else {
                setAttribute(attrInfo, at: 1)
            }
        }

        registry.register(character: self)
    }

    func attribute(_ info: AttributeInfo) -> Attribute {
        return Attribute(info: info, for: self)

    }

    func skill(_ info: SkillInfo) -> Skill? {
        return Skill(info: info, for: self)
    }

    private func setCharacteristic(_ info: CharacteristicInfo, at baseValue: DicePool) {
        // todo: check value is within acceptable range
        baseCharacteristicValues[info] = baseValue
        /*let characteristic: Characteristic
        switch info.type() {
        case .skill:
            characteristic = Skill(info: info as! SkillInfo, for: self)
        case .attribute:
            characteristic = Attribute(info: info as! AttributeInfo, for: self)
        default:
            characteristic = GenericCharacteristic(info: info, for: self)
        }
        characteristics[info] = characteristic*/
    }

    func setAttribute(_ info: AttributeInfo, at baseValue: DicePool) {
        setCharacteristic(info, at: baseValue)
    }


    func setSkill(_ info: SkillInfo, at baseValue: DicePool) {
        setCharacteristic(info, at: baseValue)
    }

    func name() -> String {
        return _name
    }

    func dicePoolSize(for info: CharacteristicInfo?) -> DicePool {
        guard let info = info else {
            return 0
        }

        guard let linked = info.linkedCharacteristic() else {
            return modifiedValue(for: info)
        }

        return dicePoolSize(for: linked) + modifiedValue(for: info)
    }

    func modifiedValue(for info: CharacteristicInfo?) -> DicePool {
        guard let info = info else {
            return 0
        }

        let base = baseValue(for: info)

        guard let modifiers = modifiers[info.primaryCharacteristic()] else {
            return base
        }

        let result: DicePool = modifiers.reduce(base, { result, modifier in result + modifier.modifier })
        return result
    }

    func baseValue(for info: CharacteristicInfo?) -> DicePool {
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

    private func characteristic(for info: CharacteristicInfo) -> Characteristic {
        let characteristic: Characteristic
        switch info.type() {
        case .skill:
            characteristic = Skill(info: info as! SkillInfo, for: self)
        case .attribute:
            characteristic = Attribute(info: info as! AttributeInfo, for: self)
        default:
            characteristic = GenericCharacteristic(info: info, for: self)
        }

        return characteristic
    }

    func attributes() -> [Attribute] {
        return baseCharacteristicValues.filter { characInfo, _ in
            characInfo.type() == .attribute
        }.map { attrInfo, _ in
            attribute(attrInfo as! AttributeInfo)
        }.filter { attr in
            attr.modifiedValue() > 0
        }.sorted()
    }

    func attributesCount() -> Int {
        return baseCharacteristicValues.filter { characInfo, _ in
            characInfo.type() == .attribute
        }.map { attrInfo, _ in
            attribute(attrInfo as! AttributeInfo)
        }.filter { attr in
            attr.modifiedValue() > 0
        }.count
    }

    func skills() -> [Skill] {
        return baseCharacteristicValues.filter { characInfo, _ in
            characInfo.type() == .skill
        }.map { attrInfo, _ in
            skill(attrInfo as! SkillInfo)!
        }.filter { attr in
            attr.modifiedValue() > 0
        }.sorted()
    }

    func skillsCount() -> Int {
        return baseCharacteristicValues.filter { characInfo, _ in
            characInfo.type() == .skill
        }.map { attrInfo, _ in
            skill(attrInfo as! SkillInfo)!
        }.filter { attr in
            attr.modifiedValue() > 0
        }.count
    }

    func roll(characteristic: CharacteristicInfo, usingEdge: Bool) -> RollResult {
        return registry.engine.roll(characteristic, for: self, usingEdge: usingEdge)
    }
}
