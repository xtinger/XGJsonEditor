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
class Lesson: NSObject, Decodable {
    var id: Int?
    var name: String?
    var path: String?
    var lessonQuickText: Question?
    
    required init(from decoder: Decoder) throws {
        super.init()
    }
}
