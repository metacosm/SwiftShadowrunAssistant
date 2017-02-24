//
//  Attribute.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 14/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

class Attribute: GenericCharacteristic {
    init(info: AttributeInfo, for character: Character) {
        super.init(info: info, for: character)
    }

    func attributeInfo() -> AttributeInfo {
        return self.info() as! AttributeInfo
    }

    func type() -> CharacteristicType {
        return .attribute
    }
}

