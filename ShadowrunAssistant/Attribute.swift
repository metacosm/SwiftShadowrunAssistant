//
//  Attribute.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 14/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

class Attribute: GenericCharacteristic, Characteristic {
    init(info: AttributeInfo, value: Int, modifiers: [Modifier]? = nil) {
        super.init(info: info, value: value, modifiers: modifiers)
    }

    init(attribute: Attribute, modifiers: [Modifier]) {
        super.init(info: attribute.info(), value: attribute.value(), modifiers: modifiers)
    }

    func attributeInfo() -> AttributeInfo {
        return self.info() as! AttributeInfo
    }

    func type() -> CharacteristicType {
        return .attribute
    }
}

