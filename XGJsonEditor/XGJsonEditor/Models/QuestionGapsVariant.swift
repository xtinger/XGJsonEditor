//
//  QuestionGapsVariant.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionGapsVariant: NSObject, Codable {
    @objc var text: String?
    
//    required init(from decoder: Decoder) throws {
//        super.init()
//    }
}

extension QuestionGapsVariant: Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let created = QuestionGapsVariant()
        return created as! T
    }
}

extension QuestionGapsVariant: Expandable {
    var isExpandable: Bool {
        return false
    }
}

extension QuestionGapsVariant: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        let valueTransformer = HTMLToAttributedString()
        valueTransformer.showEmptyMessage = true
        textField.bind(NSBindingName(rawValue: "value"), to: self, withKeyPath: "text", options: [.valueTransformer: valueTransformer])
    }
}

