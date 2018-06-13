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
    @objc var html: String?
    // текст правильного ответа
    @objc var correctAnswer: String?
    // Пишем, если ответ верный (опционально)
    @objc var correctComment: String?
    // Пишем, если ответ НЕверный (опционально)
    @objc var incorrectComment: String?
    
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
    
    override init() {
        super.init()
    }
}

extension QuestionInput: Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let created = QuestionInput()
        created.type = .input
        return created as! T
    }
}
