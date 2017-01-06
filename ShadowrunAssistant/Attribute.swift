//
//  Attribute.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 14/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

struct Modifier {
    init(value: Int) {
        self.init(name: "modifier", value: value)
    }

    init(name: String, value: Int) {
        self.init(name: name, value: value, description: nil)
    }

    init(name: String, value: Int, description: String?) {
        self.name = name
        self.modifier = value
        self.description = description
    }

    let name: String
    var modifier: Int
    let description: String?
    var modifierAsString: String {
        get {
            return modifier > 0 ? "+\(modifier)" : "\(modifier)"
        }
    }
}

struct Attribute {
    init(info: AttributeInfo, value: Int, modifiers: [Modifier]? = nil) {
        self.info = info
        self.value = value
        self.modifiers = modifiers
    }

    init(attribute: Attribute, modifiers: [Modifier]) {
        self.init(info: attribute.info, value: attribute.value, modifiers: modifiers)
    }

    let info: AttributeInfo
    var value: Int
    private var modifiers: [Modifier]?
    var modifiedValue: Int {
        get {
            if let modifiers = modifiers {
                return modifiers.reduce(value, { result, modifier in result + modifier.modifier })
            } else {
                return value
            }
        }
    }
    var modifiersAsString: String? {
        get {
            if let modifiers = modifiers {
                return "\(modifiers.map({ String($0.modifierAsString) }).joined(separator: " "))"
            }
            
            return nil
        }
    }
    var valueAsString: String {
        get {
            if let modifiers = modifiersAsString {
                return "\(value) \(modifiers)"
            } else {
                return String(value)
            }
        }
    }
    var name: String {
        get {
            return info.rawValue
        }
    }
}
