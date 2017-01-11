//
//  GenericCharacteristic.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class GenericCharacteristic {
    private let _info: CharacteristicInfo
    private let _character: Character

    init(info: CharacteristicInfo, for character: Character) {
        self._info = info
        self._character = character
    }

    func description() -> String {
        return _info.description()
    }

    func name() -> String {
        return _info.name()
    }

    func value() -> DicePool {
        return _character.baseValue(for: _info)
    }

    func info() -> CharacteristicInfo {
        return _info
    }

    func linkedCharacteristic() -> CharacteristicInfo? {
        return _info.linkedCharacteristic()
    }

    func modifiedValue() -> DicePool {
        return _character.modifiedValue(for: _info)
    }

    func modifiers() -> [Modifier]? {
        return _character.modifiers(for: _info)
    }

    func dicePoolSize() -> DicePool {
        return _character.dicePoolSize(for: _info)
    }

}
