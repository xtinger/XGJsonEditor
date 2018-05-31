//
//  QuestionPairsItem.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionPairsItem: NSObject, Codable {
    var correctVariantNumber: Int?
    // Этот текст будет показан, если ответ верный (опционально)
    @objc var correctComment: String?
    // Этот текст будет показан, если ответ неверный (опционально)
    @objc var incorrectComment: String?
    
//    required init(from decoder: Decoder) throws {
//        super.init()
//    }
}
