//
//  SkillRegistry.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class SkillRegistry {
   private var skills: [String: SkillInfo] = [String: SkillInfo]()
   private unowned let _engine: Engine

   init(_ engine: Engine) {
      self._engine = engine
   }

   var engine: Engine {
      return _engine
   }

   func skill(named: String) -> SkillInfo? {
      return skills[named]
   }

   @discardableResult func createSkillInfo(named name: String, description: String, linkedTo: AttributeInfo) ->
         SkillInfo {

      var skill = skills[name]

      if (skill != nil) {
         print("A skill named \(name) already exists")
      } else {
         skill = SkillInfo(name: name, description: description, linkedAttribute: linkedTo)
         skills[name] = skill
      }

      return skill!
   }
}
