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
    var id: Int?
    @objc var name: String?
    @objc var path: String?
    var lessonQuickTest: LessonQuickTest?
    
//    required init(from decoder: Decoder) throws {
//        super.init()
//    }
    
    static func buildLesson() -> Lesson {
        let lesson = Lesson()
        lesson.id = IDGenerator.generate()
        lesson.name = ""
        lesson.path = ""
        lesson.lessonQuickTest = LessonQuickTest()
        return lesson
    }
}
