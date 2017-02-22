//
//  CharacteristicInfo.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class CharacteristicInfo: Hashable, CustomDebugStringConvertible, Comparable {
    private let _name: String
    private let _description: String
    private let _group: CharacteristicGroup

    init(name: String, description: String, group: CharacteristicGroup = .physical) {
        _name = name
        _description = description
        _group = group
    }

    internal func name() -> String {
        return _name
    }

    internal func description() -> String {
        return _description
    }

    internal func group() -> CharacteristicGroup {
        return _group
    }

    public var hashValue: Int {
        return _name.hashValue
    }

    func primaryCharacteristic() -> CharacteristicInfo {
        return self
    }

    func linkedCharacteristic() -> CharacteristicInfo? {
        return nil
    }

    func type() -> CharacteristicType {
        return .generic
    }

    var debugDescription: String {
        var desc = "\(name()) \(type().description())"
        if let linked = linkedCharacteristic() {
            desc = desc + " [\(primaryCharacteristic().name()) + \(linked.name())]"
        }

        return desc
    }

    static func <(lhs: CharacteristicInfo, rhs: CharacteristicInfo) -> Bool {
        let equal = lhs.group() == rhs.group()
        if (equal) {
            return lhs.name() < rhs.name()
        } else {
            return lhs.group() < rhs.group()
        }
    }

    static func ==(lhs: CharacteristicInfo, rhs: CharacteristicInfo) -> Bool {
        return lhs.group() == rhs.group() && lhs.name() == rhs.name()
    }
}
