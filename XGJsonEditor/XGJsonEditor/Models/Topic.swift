//
//  Topic.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

// Тема
class Topic: NSObject, Codable {
    var id: Int?
    @objc var name: String?
    @objc var lesson: Lesson?
    @objc var test: TopicTest?
}

extension Topic: Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let topic = Topic()
        topic.id = IDGenerator.generate()
        topic.name = ""
        topic.lesson = Lesson.create()
        topic.test = TopicTest.create()
        topic.test?.parent = topic
        return topic as! T
    }
}

extension Topic: Expandable {
    var isExpandable: Bool {
        return true
    }
}

extension Topic: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        let valueTransformer = PrefixValueTransformer(prefix: "ТЕМА:")
        textField.bind(NSBindingName(rawValue: "value"), to: self, withKeyPath: "name", options: [.valueTransformer: valueTransformer])
    }
}

extension Topic: TreeNodeExpandable {
    var numberOfChildren: Int {
        return 2
    }
    
    func childAtIndex(index: Int) -> Any? {
        switch index {
        case 0:
            if let lesson = lesson {
                return lesson
            }
        case 1:
            if let test = test {
                return test
            }
        default:
            break
        }
        return nil
    }
}
