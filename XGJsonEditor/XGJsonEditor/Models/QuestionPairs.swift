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
    @objc var text: String?
    // html содержимое списка
    @objc var itemsHtml: String?
    // список описаний вопросов
    var items: [QuestionPairsItem]?
    // html содержимое списка с вариантами ответов
    var variantsHtml: String?
    // список описаний вариантов ответа
    var variants: [QuestionPairsVariant]?
    
    var itemsHtmlStructure = ItemsHtmlStructure(html: "")
    
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
        
        if let html = itemsHtml {
            self.itemsHtmlStructure = ItemsHtmlStructure(html: html)
        }
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let itemsHtmlString = itemsHtmlStructure.htmlOutput
        try container.encode(itemsHtmlString, forKey: .itemsHtml)
    }
}
