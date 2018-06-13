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

extension QuestionPairsVariant: Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let created = QuestionPairsVariant()
        return created as! T
    }
}

extension QuestionPairsVariant: Expandable {
    var isExpandable: Bool {
        return false
    }
}

extension QuestionPairsVariant: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        let valueTransformer = HTMLToAttributedString()
        valueTransformer.showEmptyMessage = true
        textField.bind(NSBindingName(rawValue: "value"), to: self, withKeyPath: "text", options: [.valueTransformer: valueTransformer])
    }
}

