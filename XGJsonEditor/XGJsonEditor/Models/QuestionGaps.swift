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
    var variants: [QuestionGapsVariant]?
    // список пропусков с указанием правильного варианта
    var items : [QuestionGapsItem]?
    
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

}

extension QuestionGaps: Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let created = QuestionGaps()
        created.type = .gaps
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
            if let variants = variants {
                return variants
            }
        case 1:
            if let items = items {
                return items
            }
        default:
            return nil
        }
        return nil
    }
}
