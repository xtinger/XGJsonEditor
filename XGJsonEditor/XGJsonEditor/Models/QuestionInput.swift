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
    
    private enum CodingKeys: String, CodingKey {
        case html, correctAnswer, correctComment, incorrectComment
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.html = try container.decode(String.self, forKey: .html)
        self.correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        self.correctComment = try container.decode(String.self, forKey: .correctComment)
        self.incorrectComment = try container.decode(String.self, forKey: .incorrectComment)
        
        try super.init(from: decoder)
    }
}
