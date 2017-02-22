//
// Created by Christophe Laprun on 16/02/2017.
// Copyright (c) 2017 Christophe Laprun. All rights reserved.
//

import Foundation

struct CharacteristicGroup: Comparable {
    private let _order: Int
    private let _name: String
    private static var groups: [Int: CharacteristicGroup] = [:]

    static let physical = try! CharacteristicGroup(order: 1, name: "Physical")
    static let mental = try! CharacteristicGroup(order: 2, name: "Mental")
    static let derived = try! CharacteristicGroup(order: 3, name: "Derived")
    static let magic = try! CharacteristicGroup(order: 4, name: "Magic")
    static let matrix = try! CharacteristicGroup(order: 5, name: "Matrix")
    static let special = try! CharacteristicGroup(order: 6, name: "Special")

    init(order: Int, name: String) throws {
        _order = order
        _name = name
        let existing = CharacteristicGroup.groups[order]
        if existing == nil {
            CharacteristicGroup.groups[order] = self
        } else {
            throw Engine.EngineError.invalidCharacteristicGroup
        }
    }

    var name: String {
        get {
            return _name
        }
    }

    var order: Int {
        get {
            return _order
        }
    }

    static func <(lhs: CharacteristicGroup, rhs: CharacteristicGroup) -> Bool {
        return lhs._order < rhs._order
    }

    static func ==(lhs: CharacteristicGroup, rhs: CharacteristicGroup) -> Bool {
        return lhs._order == rhs._order
    }

}
