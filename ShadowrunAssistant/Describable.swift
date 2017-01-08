//
//  Describable.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 08/01/2017.
//  Copyright © 2017 Christophe Laprun. All rights reserved.
//

import Foundation

protocol Describable {
    func description() -> String

    func name() -> String
}