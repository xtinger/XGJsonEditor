//
//  SectionTest.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

// тест по разделу
class SectionTest: Test {

//    required init(from decoder: Decoder) throws {
//        super.init()
//    }
}

extension SectionTest: Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let test = SectionTest()
        test.id = IDGenerator.generate()
        return test as! T
    }
}

