//
//  SectionTest.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

// тест по разделу
class TopicTest: Test {
    
//    required init(from decoder: Decoder) throws {
//        super.init()
//    }
}

extension TopicTest: Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let test = TopicTest()
        test.id = Thread.current.nextFlakeID()
        return test as! T
    }
}

extension TopicTest: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        textField.stringValue = "[Тест]"
    }
}
