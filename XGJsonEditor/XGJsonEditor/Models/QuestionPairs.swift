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
    @objc var items: [QuestionPairsItem] = []
    // html содержимое списка с вариантами ответов
    @objc var variantsHtml: String?
    // список описаний вариантов ответа
    @objc var variants: [QuestionPairsVariant] = []
    
    @objc var itemsHtmlStructure = QuestionsHtmlStructure(html: "")
    @objc var variantHtmlStructure = VariantsHtmlStructure(html: "")
    
    private enum CodingKeys: String, CodingKey {
        case text, itemsHtml, items, variantsHtml, variants
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.itemsHtml = try container.decode(String.self, forKey: .itemsHtml)
        self.items = try container.decode([QuestionPairsItem].self, forKey: .items)
        self.variantsHtml = try container.decode(String.self, forKey: .variantsHtml)
        self.variants = try container.decode([QuestionPairsVariant].self, forKey: .variants)
        
        if let html = itemsHtml {
            self.itemsHtmlStructure = QuestionsHtmlStructure(html: html)
        }
        
        if let html = variantsHtml {
            self.variantHtmlStructure = VariantsHtmlStructure(html: html)
        }
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(text, forKey: .text)
        
        let itemsHtmlString = itemsHtmlStructure.htmlOutput
        try container.encode(itemsHtmlString, forKey: .itemsHtml)
        
        let variantsHtmlString = variantHtmlStructure.htmlOutput
        try container.encode(variantsHtmlString, forKey: .variantsHtml)
        
        var variantsContainer = container.nestedUnkeyedContainer(forKey: .variants)
        try variantsContainer.encode(contentsOf: variants)
        
        var itemsContainer = container.nestedUnkeyedContainer(forKey: .items)
        try itemsContainer.encode(contentsOf: items)
    }
}

extension QuestionPairs {
    override var description:String{
        return "QuestionPairs: itemsHtmlStructure: \(itemsHtmlStructure.elements.count) \(itemsHtmlStructure.elements)"
    }
}

//extension QuestionPairs: CustomStringConvertible {
//    public override var debugDescription: String {
//        return "\(self) itemsHtmlStructure: \(itemsHtmlStructure.elements)"
//    }
//}

extension QuestionPairs: Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        
        let created = QuestionPairs()
        
        created.type = .pairs
        created.text = ""
        created.itemsHtml = ""
        created.items = [QuestionPairsItem()]
        created.variants = [QuestionPairsVariant()]
        
        let questionsHtmlStructure = QuestionsHtmlStructure()
        questionsHtmlStructure.elements = [QuestionsStructureElement(text: "")]
        created.itemsHtmlStructure = questionsHtmlStructure
        
        let variantsHtmlStructure = VariantsHtmlStructure()
        variantsHtmlStructure.elements = [VariantsStructureElement(text: "")]
        created.variantHtmlStructure = variantsHtmlStructure
        
        return created as! T
    }
}

extension QuestionPairs: Expandable {
    var isExpandable: Bool {
        return true
    }
}

extension QuestionPairs: TreeNodeExpandable {
    var numberOfChildren: Int {
        return 4
    }
    
    func childAtIndex(index: Int) -> Any? {
        switch index {
        case 0:
            return itemsHtmlStructure
        case 1:
            return items
        case 2:
            return variantHtmlStructure
        case 3:
            return variants
        default:
            break
        }
        return nil
    }
}
