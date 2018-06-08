//
//  IDGenerator.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 08/06/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class IDGenerator: NSObject {
    static func generate() -> Int {
        let g = Int(Date.init().timeIntervalSince1970 * 1000)
        return g
    }
}
