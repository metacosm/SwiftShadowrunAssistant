//
//  Skill.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class Skill: GenericCharacteristic, Characteristic {
    init(info: SkillInfo, value: Int, modifiers: [Modifier]? = nil) {
        super.init(info: info, value: value, modifiers: modifiers)
    }

    init(skill: Skill, modifiers: [Modifier]? = nil) {
        super.init(info: skill.info(), value: skill.value(), modifiers: modifiers)
    }

    func type() -> CharacteristicType {
        return .skill
    }
}
