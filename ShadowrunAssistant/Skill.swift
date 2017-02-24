//
//  Skill.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class Skill: GenericCharacteristic {
    init(info: SkillInfo, for character: Character) {
        super.init(info: info, for: character)
    }

    func skillInfo() -> SkillInfo {
        return self.info() as! SkillInfo
    }

    func type() -> CharacteristicType {
        return .skill
    }
}
