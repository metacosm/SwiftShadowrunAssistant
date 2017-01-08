//
//  Characteristic.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 06/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

protocol Characteristic: Describable {

    func value() -> Int

    func info() -> CharacteristicInfo

    func linkedCharacteristic() -> CharacteristicInfo?

    func dicePoolSize() -> Int

    func modifiers() -> [Modifier]?
}
