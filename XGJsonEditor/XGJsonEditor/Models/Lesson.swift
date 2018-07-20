//
//  Lesson.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

// Тест по лекции
// Test with one question
class Lesson: NSObject, Codable {
    var id: Int64?
    @objc var name: String?
    @objc var path: String?
    var lessonQuickTest: LessonQuickTest?
}

extension Lesson: Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let lesson = Lesson()
        lesson.id = Thread.current.nextFlakeID()
        lesson.name = ""
        lesson.path = ""
        lesson.lessonQuickTest = LessonQuickTest.create()
        lesson.lessonQuickTest?.parent = lesson
        return lesson as! T
    }
}

extension Lesson: Expandable {
    var isExpandable: Bool {
        return true
    }
}

extension Lesson: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        let valueTransformer = PrefixValueTransformer(prefix: "ЛЕКЦИЯ:")
        textField.bind(NSBindingName(rawValue: "value"), to: self, withKeyPath: "name", options: [.valueTransformer: valueTransformer])
    }
}

extension Lesson: TreeNodeExpandable {
    var numberOfChildren: Int {
        return 1
    }
    
    func childAtIndex(index: Int) -> Any? {
        switch index {
        case 0:
            if let lessonQuickTest = lessonQuickTest {
                return lessonQuickTest
            }
        default:
            break
        }
        return nil
    }
}

