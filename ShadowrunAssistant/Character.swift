//
//  Character.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

class Character {
    private let attributes: [AttributeInfo: Attribute]
    private let modifiers: [String: [Modifier]]

    required init(with attributes: [Attribute], modifiedBy: [String: [Modifier]]) {
        var attrDict: [AttributeInfo: Attribute] = [AttributeInfo: Attribute](minimumCapacity: attributes.count)
        var modDict = [String: [Modifier]](minimumCapacity: modifiedBy.count)

        attributes.forEach {
            let info = AttributeInfo(rawValue: $0.name)!
            attrDict[info] = $0
        }

        for (name, modifiers) in modifiedBy {
            modDict[name] = modifiers
        }

        self.attributes = attrDict
        self.modifiers = modDict
    }

    func attribute(_ info: AttributeInfo) -> Attribute {
        let attribute = attributes[info]!
        guard let modifiers = modifiers[info.name()] else {
            return attribute
        }

        return Attribute(attribute: attribute, modifiers: modifiers)
    }
}

class CharacterBuilder {
    private var attributes: [Attribute] = [Attribute]()
    private var modifiers: [String: [Modifier]] = [String: [Modifier]]()

    @discardableResult func attribute(_ named: AttributeInfo, with value: Int = 3) -> CharacterBuilder {
        attributes.append(Attribute(info: named, value: value))
        return self
    }

    @discardableResult func modifier(for name: String, value: Int) -> CharacterBuilder {
        let modifier = Modifier(value: value)
        if var currentModifiers = modifiers[name] {
            currentModifiers.append(modifier)
        } else {
            modifiers[name] = [modifier]
        }
        return self
    }

    func build() -> Character {
        // todo: check that character actually has values for all defined attributes

        return Character(with: attributes, modifiedBy: modifiers)
    }

}
