//
//  Question.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

enum QuestionType: String {
    case checks = "checks"
    case gaps = "gaps"
    case pairs = "pairs"
    case input = "input"
}

class Question: NSObject {
    var id: Int?
    var type: QuestionType?
}
