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
    private var _value: Int
    private var _modifiers: [Modifier]?


    init(info: CharacteristicInfo, value: Int, modifiers: [Modifier]? = nil) {
        self._info = info
        self._value = value
        self._modifiers = modifiers
    }

    convenience init(info: CharacteristicInfo, value: Int) {
        self.init(info: info, value: value, modifiers: nil)
    }

    convenience init(characteristic: Characteristic, modifiers: [Modifier]) {
        self.init(info: characteristic.info(), value: characteristic.value(), modifiers: modifiers)
    }

    func description() -> String {
        return _info.description()
    }

    func name() -> String {
        return _info.name()
    }

    func value() -> Int {
        return _value
    }

    func info() -> CharacteristicInfo {
        return _info
    }

    func linkedCharacteristic() -> CharacteristicInfo? {
        return _info.linkedCharacteristic()
    }

    func dicePoolSize() -> Int {
        if let modifiers = _modifiers {
            let result: Int = modifiers.reduce(_value, { result, modifier in result + modifier.modifier })
            return result
        } else {
            return _value
        }
    }

    func modifiers() -> [Modifier]? {
        return _modifiers
    }
}
