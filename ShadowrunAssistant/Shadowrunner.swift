//
//  Shadowrunner.swift
//  ShadowrunModel
//
//  Created by Christophe Laprun on 07/03/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

public struct Modifier {
   init(value: Int) {
      self.init(name: "modifier", value: value)
   }

   init(name: String, value: Int) {
      self.name = name
      self._modifier = value
   }

   let name: String
   let _modifier: Int
   var modifier: Int {
      return _modifier
   }
   var modifierAsString: String {
      get {
         return modifier > 0 ? "+\(modifier)" : "\(modifier)"
      }
   }
}

public class Shadowrunner: Equatable, CustomDebugStringConvertible, CustomStringConvertible {
   private var _realName: String?
   private let _name: String
   private let _registry: CharacterRegistry
   private var _modifiers: [CharacteristicInfo: [Modifier]]
   private var _characteristics: [CharacteristicInfo: Characteristic]

   init(named: String, registry: CharacterRegistry) {
      self._name = named
      self._registry = registry
      self._modifiers = [CharacteristicInfo: [Modifier]]()
      self._characteristics = [CharacteristicInfo: Characteristic]()
      
      registry.engine.attributeInfos().forEach{
         setCharacteristic($0, at: $0.initialValue)
      }
   }

   func modifiers(for info: CharacteristicInfo) -> [Modifier]? {
      return _modifiers[info]
   }

   func characteristic(_ info: CharacteristicInfo) -> Characteristic {
      guard let characteristic = _characteristics[info] else {
         return Characteristic(named: info, for: self, with: info.initialValue)
      }
      
      return characteristic

   }
   func attribute(_ info: AttributeInfo) -> Characteristic {
      return characteristic(info)
   }

   func skill(_ info: SkillInfo) -> Characteristic {
      return characteristic(info)
   }

   var characteristics: [Characteristic] {
      return getNonNullCharacteristics(with: nil)
   }

   private func getNonNullCharacteristics(with type: CharacteristicInfo.CharacteristicType?) ->
         [Characteristic] {
      
      if let type = type {
         let filtered = _characteristics.filter {
            return $0.key.type == type
            }.map {
               $0.value
            }.filter {
               $0.modifiedValue > 0
            }.sorted()
         
         
         return filtered
      } else {
         return _characteristics.map {
            $0.value
         }.filter {
            $0.modifiedValue > 0
         }.sorted()
      }
   }


   var attributes: [Characteristic] {
      return getNonNullCharacteristics(with: .attribute)
   }

   var attributesCount: Int {
      return attributes.count
   }

   var skills: [Characteristic] {
      return getNonNullCharacteristics(with: .skill)
   }

   var skillsCount: Int {
      return skills.count
   }

   func setCharacteristic(_ info: CharacteristicInfo, at value: DicePool) {
      let characteristic = Characteristic(named: info, for: self, with: value)
      _characteristics[info] = characteristic
   }

   func dicePool(for info: CharacteristicInfo) -> DicePool {
      guard let characteristic = _characteristics[info] else {
         return Characteristic(named: info, for: self, with: info.initialValue).dicePool
      }

      return characteristic.dicePool
   }

   func setModifier(for info: CharacteristicInfo?, at modifier: Modifier) {
      guard let info = info else {
         return
      }

      if var currentModifiers = _modifiers[info] {
         currentModifiers.append(modifier)
         _modifiers[info] = currentModifiers
      } else {
         _modifiers[info] = [modifier]
      }
   }

   var name: String {
      return _name
   }

   public static func ==(lhs: Shadowrunner, rhs: Shadowrunner) -> Bool {
      return lhs.name == rhs.name
   }

   public var debugDescription: String {
      return "\(name): \(characteristics)"
   }

   public var description: String {
      return debugDescription
   }
}
