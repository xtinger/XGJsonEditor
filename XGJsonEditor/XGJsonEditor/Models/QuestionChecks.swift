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
    @objc var text: String?
    var variants: [QuestionChecksVariant] = []
    
    enum CodingKeys: String, CodingKey {
        case text, variants
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.variants = try container.decode([QuestionChecksVariant].self, forKey: .variants)
        try super.init(from: decoder)
    }
    
    override init() {
        super.init()
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey:.text)
        var variantsContainer = container.nestedUnkeyedContainer(forKey: .variants)
        try variantsContainer.encode(contentsOf: variants)
    }
}

extension QuestionChecks : CreatableByType {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let created = QuestionChecks()
        created.type = .checks
        return created as! T
    }
}
