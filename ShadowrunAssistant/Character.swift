//
//  Character.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

class Character {
    private let attributes: [String : Attribute]
    required init(with attributes: [Attribute]) {
        self.attributes = [String: Attribute]()
        attributes.forEach{
            self.attributes[$0.name] = $0
        }
    }

    
    func attribute(named: String) -> Attribute? {
        return attributes[named]
    }
}

struct CharacterBuilder {
    private var attributes : [Attribute] = [Attribute]()

    @discardableResult mutating func attribute(named: String, with value: Int) -> CharacterBuilder {
        attributes.append(Attribute(name: named, value: value))
        return self
    }
    
    func build() -> Character {
        return Character(with: attributes)
    }
}
