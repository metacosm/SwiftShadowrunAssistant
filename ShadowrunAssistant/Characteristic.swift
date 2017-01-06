//
//  Characteristic.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 06/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class Characteristic<T:Describable>: Describable {
    private let _info: T
    private var _value: Int
    private let _linkedAttribute: AttributeInfo?
    private var modifiers: [Modifier]?

    init(info: T, value: Int, modifiers: [Modifier]? = nil, with linked: AttributeInfo? = nil) {
        self._info = info
        _linkedAttribute = linked
        self._value = value
        self.modifiers = modifiers
    }

    convenience init(info: T, value: Int) {
        self.init(info: info, value: value, modifiers: nil, with: nil)
    }

    convenience init(characteristic: Characteristic<T>, modifiers: [Modifier]) {
        self.init(info: characteristic.info(), value: characteristic.value(), modifiers: modifiers, with: characteristic._linkedAttribute)
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

    func info() -> T {
        return _info
    }

    func linkedAttribute() -> AttributeInfo? {
        return _linkedAttribute
    }

    var rollingValue: Int {
        get {
            if let modifiers = modifiers {
                let result: Int = modifiers.reduce(_value, { result, modifier in result + modifier.modifier })
                return result
            } else {
                return _value
            }
        }
    }

    var modifiersAsString: String? {
        get {
            if let modifiers = modifiers {
                return "\(modifiers.map({ String($0.modifierAsString) }).joined(separator: " "))"
            }

            return nil
        }
    }

    var valueAsString: String {
        get {
            if let modifiers = modifiersAsString {
                return "\(_value) \(modifiers)"
            } else {
                return String(_value)
            }
        }
    }
}
