//
// Created by Christophe Laprun on 17/02/2017.
// Copyright (c) 2017 Christophe Laprun. All rights reserved.
//

import XCTest
@testable import ShadowrunAssistant

class CharacteristicInfoTests: XCTestCase {
    func testCharacteristicInfoOrdering() {
        let agility = CharacteristicInfo(name: "agility", description: "agility")
        let agility2 = CharacteristicInfo(name: "agility", description: "agility", group: .physical)
        XCTAssert(agility == agility2)

        let charisma = CharacteristicInfo(name: "charisma", description: "charisma", group: .mental)
        XCTAssert(agility < charisma)

        let strength = CharacteristicInfo(name: "strength", description: "strength")
        XCTAssert(agility < strength)

        let body = CharacteristicInfo(name: "body", description: "body")
        XCTAssert(body < strength)
    }

    func testSortingCharacteristicInfo() {

    }
}
