//
//  AttributeInfo.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

class AttributeInfo: CharacteristicInfo {

    private var primary: AttributeInfo!
    private var secondary: AttributeInfo!
    private let decreasing: Bool
    private let augmentation: Augmentation!

    init(name: String, description: String, decreasing: Bool = false, augmentation: Augmentation? = nil,
         group: CharacteristicGroup = .physical) {
        self.decreasing = decreasing
        self.augmentation = augmentation

        super.init(name: name, description: description, group: group)
    }

    convenience init(name: String, description: String, primary: AttributeInfo, secondary: AttributeInfo,
                     augmentation: Augmentation? = nil) {
        self.init(name: name, description: description, decreasing: false, augmentation: augmentation, group: .derived)

        self.primary = primary
        self.secondary = secondary
    }

    override func primaryCharacteristic() -> CharacteristicInfo {
        return primary != nil ? primary : self
    }

    override func linkedCharacteristic() -> CharacteristicInfo? {
        return secondary
    }

    override func type() -> CharacteristicType {
        return .attribute
    }

    func isDerived() -> Bool {
        return secondary != nil
    }

    func isMandatory() -> Bool {
        return group() == .physical || group() == .mental || group() == .special
    }

    func isDecreasing() -> Bool {
        return decreasing
    }
}
