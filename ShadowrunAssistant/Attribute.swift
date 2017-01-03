//
//  Attribute.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 14/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import Foundation

struct Modifier {
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
    init(name: String, value: Int, modifiers: Int...) {
        self.name = name
        self.value = value
        self.modifiers = modifiers.map({Modifier(name:"modifier", value: $0)})
    }
    
    let name: String
    private var value: Int
    private var modifiers : [Modifier]?
    var modifiedValue : Int  {
        get {
            if let modifiers = modifiers {
                return modifiers.reduce(value, {result, modifier in result + modifier.modifier})
            } else {
                return value
            }
        }
    }
    var valueAsString : String {
        get {
            if let modifiers = modifiers {
                return "\(value) (\(modifiers.map({String($0.modifierAsString)}).joined(separator: " "))) = \(modifiedValue)"
            } else {
                return String(value)
            }
        }
    }
}
