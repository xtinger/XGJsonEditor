//
//  SectionTest.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

// тест по разделу
class SectionTest: NSObject, Decodable {
    var id: Int?
    var questions: [Question]?
    
    required init(from decoder: Decoder) throws {
        super.init()
    }
}
