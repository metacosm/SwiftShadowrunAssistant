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
                .modifier(for: AttributeInfo.reaction, value: 2)
                .attribute(.strength, with: 6)
                .attribute(.willpower, with: 4)
                .skill(katana, with: 4)
                .modifier(for: katana, value: 2)
                .modifier(for: katana, value: 3)
                .build()
    }

}

class CharacterBuilder {
    private let registry: CharacterRegistry
    private let name: String
    typealias AttributeValue = (AttributeInfo, DicePool)
    private var attributes: [AttributeValue] = [AttributeValue]()
    private var modifiers: [String: [Modifier]] = [String: [Modifier]]()
    typealias SkillValue = (SkillInfo, DicePool)
    private var skills: [SkillValue] = [SkillValue]()
    private var character: Character

    fileprivate init(name: String, registry: CharacterRegistry) {
        self.name = name
        self.registry = registry

        self.character = Character(name: name)
        registry.register(character: character)
    }

    @discardableResult func attribute(_ named: AttributeInfo, with value: DicePool = 3) -> CharacterBuilder {
        attributes.append((named, value))
        return self
    }

    @discardableResult func modifier(for info: CharacteristicInfo, value: DicePool) -> CharacterBuilder {
        let modifier = Modifier(value: value)
        character.setModifier(for: info, at: modifier)

        return self
    }

    @discardableResult func skill(_ named: SkillInfo, with value: DicePool = 1) -> CharacterBuilder {
        skills.append((named, value))
        return self
    }

    func build() -> Character {
        // todo: check that character actually has values for all defined attributes

        attributes.forEach {
            character.setAttribute($0.0, at: $0.1)
        }
        skills.forEach {
            character.setSkill($0.0, at: $0.1)
        }

        return character
    }

}
