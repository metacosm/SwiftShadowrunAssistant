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
    private unowned let engine: Engine

    init(_ engine: Engine) {
        self.engine = engine
    }

    func skill(named: String) -> SkillInfo? {
        return skills[named]
    }

    func createSkillInfo(name: String, description: String, linkedAttribute: AttributeInfo) -> SkillInfo {
        var skill = self.skill(named: name)

        if skill == nil {
            skill = SkillInfo(name: name, description: description, linkedAttribute: linkedAttribute)
            skills[name] = skill
        }

        return skill!
    }
}
