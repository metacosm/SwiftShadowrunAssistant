//
//  ShadowrunAssistantTests.swift
//  ShadowrunAssistantTests
//
//  Created by Christophe Laprun on 14/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import XCTest
@testable import ShadowrunAssistant

class ShadowrunAssistantTests: XCTestCase {
    private var engine: Engine! = nil
    private var zetsubo: ShadowrunAssistant.Character! = nil

    override func setUp() {
        super.setUp()

        engine = Engine()
        zetsubo = engine.createCharacter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCheckThatCharacterHasNonNilKnownAttributes() {
        do {
            try zetsubo.attribute(named: "foo")
            XCTFail()
        } catch {
         
        }
        
        do {
            for attribute in engine.attributeNames() {
                try zetsubo.attribute(named: attribute)
            }
        } catch {
            XCTFail()
        }
        
    }

    func testCheckInitiativeIsCorrectlyRolled() throws {
        let initiative = try engine.rollInitiative(character: zetsubo, usingEdge: false)
        XCTAssert(initiative == )
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
