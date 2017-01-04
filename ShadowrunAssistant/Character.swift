//
//  Character.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

class Character {
    private var attributes: [AttributeInfo: Attribute]
    private let modifiers: [String: [Modifier]]

    required init(with attributes: [Attribute]) {
        self.attributes = [AttributeInfo: Attribute]()
        self.modifiers = [String: [Modifier]]()

        attributes.forEach {
            let info = AttributeInfo(rawValue: $0.name)!
            self.attributes[info] = $0
        }
    }

    func attribute(_ info: AttributeInfo) -> Attribute {
        let attribute = attributes[info]!
        guard let modifiers = modifiers[info.rawValue] else {
            return attribute
        }

        return Attribute(attribute: attribute, modifiers: modifiers)
    }
}

class CharacterBuilder {
    private var attributes: [Attribute] = [Attribute]()

    @discardableResult func attribute(_ named: AttributeInfo, with value: Int = 3) -> CharacterBuilder {
        attributes.append(Attribute(info: named, value: value))
        return self
    }

    func build() -> Character {
        // todo: check that character actually has values for all defined attributes

        return Character(with: attributes)
    }

}
