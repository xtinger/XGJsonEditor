//
//  QuestionGaps.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionGaps: Question {
    // html
    var text: String?
    // список названий на кнопках с вариантами
    var variants: [QuestionGapsVariant]?
    // список пропусков с указанием правильного варианта
    var items : [QuestionGapsItem]?
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
