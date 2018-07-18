//
//  LessonQuickTest.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class LessonQuickTest: Test {
    // one question
    
//    required init(from decoder: Decoder) throws {
//        try super.init(from: decoder)
//    }
}

extension LessonQuickTest: Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let test = LessonQuickTest()
        test.id = IDGenerator.generate()
        return test as! T
    }
}

extension LessonQuickTest: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        textField.stringValue = "[Вопрос по лекции]"
    }
}
