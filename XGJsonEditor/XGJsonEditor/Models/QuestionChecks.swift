//
//  QuestionChecks.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionChecks: Question {
    // Текст, который показывается перед вариантами с чекбоксами
    var text: String?
    var variants: [QuestionChecksVariant]?
    
    enum CodingKeys: String, CodingKey {
        case text, variants
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.variants = try container.decode([QuestionChecksVariant].self, forKey: .variants)
        try super.init(from: decoder)
    }
    
//    required init(from decoder: Decoder) throws {
//        try super.init(from: decoder)   
//    }
}
