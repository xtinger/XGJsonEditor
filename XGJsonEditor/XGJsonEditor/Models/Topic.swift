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
