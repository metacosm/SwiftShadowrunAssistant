//
// Created by Christophe Laprun on 15/03/2017.
// Copyright (c) 2017 Christophe Laprun. All rights reserved.
//

import Foundation

struct Metatype {
   let name: String
   private let ranges: [CharacteristicInfo: CharacteristicRange]

   public static let human = Metatype(name: "human", ranges: [
         Engine.body: Engine.defaultAttributeRange,
         Engine.agility: Engine.defaultAttributeRange,
         Engine.reaction: Engine.defaultAttributeRange,
         Engine.strength: Engine.defaultAttributeRange,
         Engine.charisma: Engine.defaultAttributeRange,
         Engine.intuition: Engine.defaultAttributeRange,
         Engine.logic: Engine.defaultAttributeRange,
         Engine.willpower: Engine.defaultAttributeRange
   ])

   public static let ork = human.deriveMetatype(named: "ork", with: [Engine.body: 3, Engine.strength: 2, Engine.charisma: -1, Engine.logic: -1])

   public static let dwarf = human.deriveMetatype(named: "dwarf", with: [Engine.body: 1, Engine.reaction: -1, Engine.strength: 2, Engine.willpower: 1])

   public static let elf = human.deriveMetatype(named: "elf", with: [Engine.agility: 1, Engine.charisma: 2])

   public static let troll = human.deriveMetatype(named: "troll", with: [Engine.body: 4, Engine.agility: -1, Engine.strength: 4, Engine.charisma: -2, Engine.intuition: -1, Engine.logic: -1])


   func deriveMetatype(named name: String, with modifiers: [CharacteristicInfo: Int]) -> Metatype {
      var newRanges: [CharacteristicInfo: CharacteristicRange] = [:]
      ranges.forEach {
         attribute, range in
         if let rangeModifier = modifiers[attribute] {
            newRanges[attribute] = range + rangeModifier
         } else {
            newRanges[attribute] = range
         }
      }

      return Metatype(name: name, ranges: newRanges)
   }

   func baseRange(for info: CharacteristicInfo) -> CharacteristicRange {
      if let range = ranges[info] {
         return range
      } else {
         switch info.type {
         case .attribute:
            return Engine.defaultAttributeRange
         case .skill:
            return Engine.defaultSkillRange
         }
      }
   }
}
