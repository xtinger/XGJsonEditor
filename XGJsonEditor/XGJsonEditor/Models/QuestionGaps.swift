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
    @objc var text: String?
    // список названий на кнопках с вариантами
    @objc var variants: [QuestionGapsVariant] = []
    // список пропусков с указанием правильного варианта
    @objc var items : [QuestionGapsItem] = []
    
    private enum CodingKeys: String, CodingKey {
        case text, variants, items
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.variants = try container.decode([QuestionGapsVariant].self, forKey: .variants)
        self.items = try container.decode([QuestionGapsItem].self, forKey: .items)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(text, forKey: .text)
        
        var variantsContainer = container.nestedUnkeyedContainer(forKey: .variants)
        try variantsContainer.encode(contentsOf: variants)

        var itemsContainer = container.nestedUnkeyedContainer(forKey: .items)
        try itemsContainer.encode(contentsOf: items)
    }

}

extension QuestionGaps: Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let created = QuestionGaps()
        created.type = .gaps
        created.text = ""
        created.variants = [QuestionGapsVariant.create()]
        created.items = [QuestionGapsItem.create()]
        return created as! T
    }
}

extension QuestionGaps: Expandable {
    var isExpandable: Bool {
        return true
    }
}

extension QuestionGaps: TreeNodeExpandable {
    var numberOfChildren: Int {
        return 2
    }
    
    func childAtIndex(index: Int) -> Any? {
        switch index {
        case 0:
            return variants
        case 1:
            return items
        default:
            return nil
        }
    }
}
