//
//  CharacteristicType.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

enum CharacteristicType {
    case attribute, skill, generic

    func description() -> String {
        switch self {
        case .attribute:
            return "Attribute"
        case .skill:
            return "Skill"
        default:
            return "Characteristic"
        }
    }
}
