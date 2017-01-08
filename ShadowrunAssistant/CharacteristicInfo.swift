//
//  CharacteristicInfo.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class CharacteristicInfo: Describable, Hashable {
    private let _name: String
    private let _description: String

    init(name: String, description: String) {
        _name = name
        _description = description
    }

    internal func name() -> String {
        return _name
    }

    internal func description() -> String {
        return _description
    }

    public var hashValue: Int {
        return _name.hashValue
    }

    public static func ==(lhs: CharacteristicInfo, rhs: CharacteristicInfo) -> Bool {
        return lhs._name == rhs._name
    }

    func linkedCharacteristic() -> CharacteristicInfo? {
        return nil
    }

    func type() -> CharacteristicType {
        return .generic
    }
}
