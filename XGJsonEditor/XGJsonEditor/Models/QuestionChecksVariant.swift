//
//  QuestionChecksVariant.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionChecksVariant: NSObject {
    var text: String?
    var isCorrect: Bool?
    // Этот текст будет показан, если чекбокс стоит и ответ верный, или если чекбокса нет и ответ неверный (опционально)
    var correctComment: String?
    // Этот текст будет показан, если чекбокс стоит и ответ неверный, или если чекбокса нет и ответ верный (опционально)
    var incorrectComment: String?
    
}