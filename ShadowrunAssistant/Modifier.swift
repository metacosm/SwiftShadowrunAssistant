//
//  Modifier.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
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
