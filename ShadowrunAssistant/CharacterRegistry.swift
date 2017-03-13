//
//  CharacterRegistry.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 09/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class CharacterRegistry {
   private var characters: [String: Shadowrunner] = [String: Shadowrunner]()
   private let _engine: Engine
   private var _zetsubo: Shadowrunner! = nil

   init(_ engine: Engine) {
      self._engine = engine
      
      let registry = _engine.skillRegistry()
      let katana = registry.createSkillInfo(named: "katana", description: "katana", linkedTo: Engine.agility)
      let assaultRifle = registry.createSkillInfo(named: "assault rifle", description: "", linkedTo: Engine.agility)
      _zetsubo = getCharacterBuilder(characterNamed: "Zetsubo")
            .attribute(Engine.agility, with: 5)
            .attribute(Engine.body, with: 6)
            .attribute(Engine.charisma, with: 2)
            .attribute(Engine.edge, with: 4)
            .attribute(Engine.intuition, with: 4)
            .attribute(Engine.logic, with: 3)
            .attribute(Engine.reaction, with: 5)
            .modifier(for: Engine.reaction, value: 2)
            .attribute(Engine.strength, with: 6)
            .attribute(Engine.willpower, with: 4)
            .attribute(Engine.magic, with: 6)
            .skill(katana, with: 4)
            .modifier(for: katana, value: 2)
            .modifier(for: katana, value: 3)
            .skill(assaultRifle, with: 1)
            .build()
   }

   var engine: Engine {
      get {
         return _engine
      }
   }

   func character(named: String) -> Shadowrunner? {
      return characters[named]
   }

   func getCharacterBuilder(characterNamed: String) -> CharacterBuilder {
      return CharacterBuilder(name: characterNamed, registry: self)
   }

   func register(character: Shadowrunner) {
      characters[character.name] = character
   }

   func zetsubo() -> Shadowrunner {
      return _zetsubo
   }

}

class CharacterBuilder {
   private let registry: CharacterRegistry
   private let name: String
   private var modifiers: [String: [Modifier]] = [String: [Modifier]]()
   private var characteristics: [Characteristic] = [Characteristic]()
   private var character: Shadowrunner

   fileprivate init(name: String, registry: CharacterRegistry) {
      self.name = name
      self.registry = registry

      self.character = Shadowrunner(named: name, registry: registry)
      registry.register(character: character)
   }

   @discardableResult func attribute(_ named: AttributeInfo, with value: DicePool = 3) -> CharacterBuilder {
      characteristics.append(Characteristic(named: named, for: character, with: value))
      return self
   }

   @discardableResult func modifier(for info: CharacteristicInfo, value: DicePool) -> CharacterBuilder {
      let modifier = Modifier(value: value)
      character.setModifier(for: info, at: modifier)

      return self
   }

   @discardableResult func skill(_ named: SkillInfo, with value: DicePool = 1) -> CharacterBuilder {
      characteristics.append(Characteristic(named: named, for: character, with: value))
      return self
   }

   func build() -> Shadowrunner {
      // todo: check that character actually has values for all defined attributes

      characteristics.forEach {
         character.setCharacteristic($0.info, at: $0.baseValue)
      }

      return character
   }

}
