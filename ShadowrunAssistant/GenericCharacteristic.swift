//
//  GenericCharacteristic.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class GenericCharacteristicInfo: Hashable, CustomDebugStringConvertible, Comparable {
   private let _name: String
   private let _description: String
   private let _group: CharacteristicGroup

   init(name: String, description: String, group: CharacteristicGroup = .physical) {
      _name = name
      _description = description
      _group = group
   }

   var initialValue: DicePool {
      return 0
   }

   var name: String {
      return _name
   }

   var description: String {
      return _description
   }

   var group: CharacteristicGroup {
      return _group
   }

   public var hashValue: Int {
      return _name.hashValue
   }

   var type: CharacteristicType {
      return .generic
   }

   var debugDescription: String {
      return "\(name) \(type.description())"
   }

   static func <(lhs: GenericCharacteristicInfo, rhs: GenericCharacteristicInfo) -> Bool {
      let equal = lhs.group == rhs.group
      if (equal) {
         return lhs.name < rhs.name
      } else {
         return lhs.group < rhs.group
      }
   }

   static func ==(lhs: GenericCharacteristicInfo, rhs: GenericCharacteristicInfo) -> Bool {
      return lhs.group == rhs.group && lhs.name == rhs.name
   }
}

class BaseAttributeInfo: GenericCharacteristicInfo {
   var isDerived: Bool {
      return false
   }

   override var type: CharacteristicType {
      return .attribute
   }
}

class SimpleAttributeInfo: BaseAttributeInfo {
   private let _initialValue: DicePool

   init(name: String, description: String, group: CharacteristicGroup = .physical, initialValue: DicePool = 0) {
      _initialValue = initialValue
      super.init(name: name, description: description, group: group)
   }

   override var initialValue: DicePool {
      return _initialValue
   }
}

class DerivedAttributeInfo: BaseAttributeInfo {
   private let _first: BaseAttributeInfo
   private let _second: BaseAttributeInfo

   init(name: String, description: String, group: CharacteristicGroup = .physical, first: BaseAttributeInfo, second: BaseAttributeInfo) {
      _first = first
      _second = second

      super.init(name: name, description: description, group: group)
   }

   override var isDerived: Bool {
      return true
   }

   override var initialValue: DicePool {
      return first.initialValue + second.initialValue
   }

   var first: BaseAttributeInfo {
      return _first
   }

   var second: BaseAttributeInfo {
      return _second
   }
}

class BaseSkillInfo: GenericCharacteristicInfo {
   private let _attribute: BaseAttributeInfo
   private let _canDefault: Bool = true

   init(name: String, description: String, group: CharacteristicGroup = .physical, linkedAttribute: BaseAttributeInfo, canDefault: Bool = true) {
      _attribute = linkedAttribute
      _canDefault = canDefault
      super.init(name: name, description: description, group: group)
   }

   override var type: CharacteristicType {
      return .skill
   }

   var linkedAttribute: BaseAttributeInfo {
      return _attribute
   }

   var canDefault: Bool {
      return _canDefault
   }
}

class NewGenericCharacteristic<T:GenericCharacteristicInfo>: Comparable, CustomDebugStringConvertible {
   private let _info: T
   private let _character: Character

   var info: T {
      get {
         return _info
      }
   }

   var character: Character {
      get {
         return _character
      }
   }

   init(info: T, for character: Character) {
      self._info = info
      self._character = character
   }

   var dicePool: DicePool {
      return modifiedValue
   }

   var modifiers: [Modifier]? {
      get {
         return character.modifiers(for: info)
      }
   }

   func roll(usingEdge: Bool) -> RollResult {
      return character.roll(characteristic: info, usingEdge: usingEdge)
   }

   var name: String {
      return info.name
   }

   var description: String {
      return info.description
   }

   static func <(lhs: NewGenericCharacteristic, rhs: NewGenericCharacteristic) -> Bool {
      let lInfo = lhs.info
      let rInfo = rhs.info
      if lInfo == rInfo {
         return lhs.value < rhs.value
      } else {
         return lInfo < rInfo
      }
   }

   static func ==(lhs: NewGenericCharacteristic, rhs: NewGenericCharacteristic) -> Bool {
      return lhs.info == rhs.info && lhs.character == rhs.character
   }

   var debugDescription: String {
      return "\(info.debugDescription): \(modifiedValue)"
   }

   var modifiedValue: DicePool {
      guard let modifiers = modifiers else {
         return value
      }

      let result: DicePool = modifiers.reduce(value, { result, modifier in result + modifier.modifier })
      return result
   }

   var value: DicePool {
      get {
      }
      set {
      }
   }
}

class BaseAttribute<T:BaseAttributeInfo>: NewGenericCharacteristic<T> {

}

class SimpleAttribute: BaseAttributeInfo<SimpleAttributeInfo> {
   private var _value: DicePool = 0

   override var value: DicePool {
      get {
         return _value
      }

      set {
         _value = newValue
      }
   }
}

class DerivedAttribute: BaseAttributeInfo<DerivedAttributeInfo> {

   override var value: DicePool {
      get {
         return character.attribute(info.first).value + character.attribute(info.second).value
      }
      set {
      }
   }
}

class BaseSkill: GenericCharacteristicInfo<BaseSkillInfo> {
   private var _value: DicePool = 0

   override var value: DicePool {
      get {
         return _value
      }

      set {
         _value = newValue
      }
   }

   override var dicePool: DicePool {
      return modifiedValue + character.attribute(info.linkedAttribute).dicePool
   }
}


class GenericCharacteristic: Comparable, CustomDebugStringConvertible, Characteristic {
   private let _info: CharacteristicInfo
   private let _character: Character

   init(info: CharacteristicInfo, for character: Character) {
      self._info = info
      self._character = character
   }

   func description() -> String {
      return _info.description()
   }

   func name() -> String {
      return _info.name()
   }

   func value() -> DicePool {
      return _character.baseValue(for: _info)
   }

   func info() -> CharacteristicInfo {
      return _info
   }

   func linkedCharacteristic() -> CharacteristicInfo? {
      return _info.linkedCharacteristic()
   }

   func modifiedValue() -> DicePool {
      return _character.modifiedValue(for: _info)
   }

   func modifiers() -> [Modifier]? {
      return _character.modifiers(for: _info)
   }

   func dicePoolSize() -> DicePool {
      return _character.dicePoolSize(for: _info)
   }

   func roll(usingEdge: Bool) -> RollResult {
      return _character.roll(characteristic: info(), usingEdge: usingEdge)
   }


   static func <(lhs: GenericCharacteristic, rhs: GenericCharacteristic) -> Bool {
      let lInfo = lhs._info
      let rInfo = rhs._info
      if (lInfo.group() == rInfo.group()) {
         if (lInfo.name() == rhs.name()) {
            return lhs.modifiedValue() < rhs.modifiedValue()
         } else {
            return lInfo.name() < rInfo.name()
         }
      } else {
         return lInfo.group() < rInfo.group()
      }
   }

   static func ==(lhs: GenericCharacteristic, rhs: GenericCharacteristic) -> Bool {
      return lhs._info.group() == rhs._info.group() && lhs._info.name() == rhs._info.name()
              && lhs.modifiedValue() == rhs.modifiedValue()
   }

   var debugDescription: String {
      return "\(_info.debugDescription): \(modifiedValue())"
   }
   
}

