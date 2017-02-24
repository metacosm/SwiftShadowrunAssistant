//
//  GenericCharacteristic.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class GenericCharacteristic: Comparable, CustomDebugStringConvertible, Characteristic {
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

    func roll(usingEdge: Bool) -> RollResult {
        return _character.roll(characteristic: info(), usingEdge: usingEdge)
    }


    static func <(lhs: GenericCharacteristic, rhs: GenericCharacteristic) -> Bool {
        let lInfo = lhs._info
        let rInfo = rhs._info
        if (lInfo.group() == rInfo.group()) {
            if (lInfo.name() == rhs.name()) {
                return lhs.modifiedValue() < rhs.modifiedValue()
            } else {
                return lInfo.name() < rInfo.name()
            }
        } else {
            return lInfo.group() < rInfo.group()
        }
    }

    static func ==(lhs: GenericCharacteristic, rhs: GenericCharacteristic) -> Bool {
        return lhs._info.group() == rhs._info.group() && lhs._info.name() == rhs._info.name()
                && lhs.modifiedValue() == rhs.modifiedValue()
    }

    var debugDescription: String {
        return "\(_info.debugDescription): \(modifiedValue())"
    }

}
