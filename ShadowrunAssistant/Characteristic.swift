//
//  Characteristic.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 06/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

public typealias DicePool = UInt

protocol Characteristic: Describable {

    func value() -> DicePool

    func modifiedValue() -> DicePool

    func info() -> CharacteristicInfo

    func linkedCharacteristic() -> CharacteristicInfo?

    func dicePoolSize() -> DicePool

    func modifiers() -> [Modifier]?

    func roll(usingEdge: Bool) -> RollResult
}
