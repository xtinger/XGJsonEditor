//
//  QuestionChecksVariant.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionChecksVariant: NSObject, Codable {
    @objc var text: String?
    @objc var isCorrect: Bool = false
    // Этот текст будет показан, если чекбокс стоит и ответ верный, или если чекбокса нет и ответ неверный (опционально)
    @objc var correctComment: String?
    // Этот текст будет показан, если чекбокс стоит и ответ неверный, или если чекбокса нет и ответ верный (опционально)
    @objc var incorrectComment: String?
    
//    required init(from decoder: Decoder) throws {
//        super.init()
//    }
    
    
}

extension QuestionChecksVariant : Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let created = QuestionChecksVariant()
        created.isCorrect = false
        
        return created as! T
    }
}
