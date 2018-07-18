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
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(html, forKey: .html)
        try container.encode(correctAnswer, forKey: .correctAnswer)
        try container.encode(correctComment, forKey: .correctComment)
        try container.encode(incorrectComment, forKey: .incorrectComment)
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
        created.html = ""
        
        return created as! T
    }
}

extension QuestionInput: Expandable {
    var isExpandable: Bool {
        return false
    }
}

