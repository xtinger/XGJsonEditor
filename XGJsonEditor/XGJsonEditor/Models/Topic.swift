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
    var lesson: Lesson?
    var test: TopicTest?
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

