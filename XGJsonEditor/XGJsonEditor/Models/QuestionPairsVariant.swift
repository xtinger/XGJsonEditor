//
//  QuestionPairsVariant.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionPairsVariant: NSObject, Codable {
    //просто порядковый номер варианта [1..N]
    var number: Int?
    // текст варианта ответа
    @objc var text: String?
    
//    required init(from decoder: Decoder) throws {
//        super.init()
//    }
}
