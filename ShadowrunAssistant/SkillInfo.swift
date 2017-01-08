//
//  SkillInfo.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class SkillInfo: CharacteristicInfo {
    private let linkedAttribute: AttributeInfo

    init(name: String, description: String, linkedAttribute: AttributeInfo) {
        self.linkedAttribute = linkedAttribute
        super.init(name: name, description: description)
    }

    override func type() -> CharacteristicType {
        return .skill
    }

    override func linkedCharacteristic() -> CharacteristicInfo? {
        return linkedAttribute
    }
}
