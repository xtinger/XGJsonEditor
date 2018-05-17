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
    
    private enum CodingKeys: String, CodingKey {
        case text, variants, items
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.variants = try container.decode([QuestionGapsVariant].self, forKey: .variants)
        self.items = try container.decode([QuestionGapsItem].self, forKey: .items)
        try super.init(from: decoder)
    }

}
