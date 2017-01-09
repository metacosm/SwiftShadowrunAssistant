//
//  CharacterRegistry.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 09/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class CharacterRegistry {
    private var characters: [String: ShadowrunAssistant.Character] = [String: Character]()
    private let engine: Engine

    init(_ engine: Engine) {
        self.engine = engine
    }

    func character(named: String) -> Character? {
        return characters[named]
    }

    func getCharacterBuilder(characterNamed: String) -> CharacterBuilder {
        return CharacterBuilder(name: characterNamed, registry: self)
    }

    fileprivate func register(character: Character) {
        characters[character.name()] = character
    }

    func zetsubo() -> Character {
        let registry = engine.skillRegistry()
        let katana = registry.createSkillInfo(name: "katana", description: "katana", linkedAttribute: .agility)
        return getCharacterBuilder(characterNamed: "Zetsubo")
                .attribute(.agility, with: 5)
                .attribute(.body, with: 6)
                .attribute(.charisma, with: 2)
                .attribute(.edge, with: 3)
                .attribute(.intuition, with: 4)
                .attribute(.logic, with: 3)
                .attribute(.reaction, with: 5)
                .modifier(for: AttributeInfo.reaction.name(), value: 2)
                .attribute(.strength, with: 6)
                .attribute(.willpower, with: 4)
                .skill(katana, with: 4)
                .modifier(for: "katana", value: 2)
                .modifier(for: "katana", value: 3)
                .build()
    }

}

class CharacterBuilder {
    private let registry: CharacterRegistry
    private let name: String
    private var attributes: [Attribute] = [Attribute]()
    private var modifiers: [String: [Modifier]] = [String: [Modifier]]()
    private var skills: [Skill] = [Skill]()

    fileprivate init(name: String, registry: CharacterRegistry) {
        self.name = name
        self.registry = registry
    }

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

    @discardableResult func skill(_ named: SkillInfo, with value: Int = 1) -> CharacterBuilder {
        skills.append(Skill(info: named, value: value, modifiers: []))
        return self
    }

    func build() -> Character {
        // todo: check that character actually has values for all defined attributes

        let character = Character(name: name, attributes: attributes, skills: skills, modifiedBy: modifiers)
        registry.register(character: character)

        return character
    }

}
