//
//  Question.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

enum QuestionType: String, Codable {
    case checks = "checks"
    case gaps = "gaps"
    case pairs = "pairs"
    case input = "input"
}

class Question: NSObject, Codable {
    var id: Int64?
    var type: QuestionType?
}

extension Question: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        if let type = self.type?.rawValue {
            textField.stringValue = type
        }
    }
}
