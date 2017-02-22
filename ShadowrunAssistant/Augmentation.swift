//
// Created by Christophe Laprun on 05/02/2017.
// Copyright (c) 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class Augmentation {
    let modifiers: [CharacteristicInfo: Modifier]
    let description: String!

    init(modifiers: [CharacteristicInfo: Modifier], description: String?) {
        self.modifiers = modifiers
        self.description = description
    }
}
