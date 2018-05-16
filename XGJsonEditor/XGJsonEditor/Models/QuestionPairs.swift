//
//  QuestionPairs.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionPairs: Question {
    // html содержимое или обычный текст (Установите соответствие...)
    var text: String?
    // html содержимое списка
    var itemsHtml: String?
    // список описаний вопросов
    var items: [QuestionPairsItem]?
    // html содержимое списка с вариантами ответов
    var variantsHtml: String?
    // список описаний вариантов ответа
    var variants: [QuestionPairsVariant]?
    
    private enum CodingKeys: String, CodingKey {
        case text, itemsHtml, items, variantsHtml, variants
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.itemsHtml = try container.decode(String.self, forKey: .itemsHtml)
        self.items = try container.decode([QuestionPairsItem].self, forKey: .items)
        self.variantsHtml = try container.decode(String.self, forKey: .variantsHtml)
        self.variants = try container.decode([QuestionPairsVariant].self, forKey: .variants)
        
        try super.init(from: decoder)
    }
}
