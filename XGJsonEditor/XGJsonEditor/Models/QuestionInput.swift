//
//  QuestionInput.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionInput: Question {
    // html содержимое вопроса
    var html: String?
    // текст правильного ответа
    var correctAnswer: String?
    // Пишем, если ответ верный (опционально)
    var correctComment: String?
    // Пишем, если ответ НЕверный (опционально)
    var incorrectComment: String?
}
