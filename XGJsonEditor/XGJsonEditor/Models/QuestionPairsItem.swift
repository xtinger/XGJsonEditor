//
//  QuestionPairsItem.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionPairsItem: NSObject, Codable {
    
    var correctVariantNumber: Int = 0
    @objc var correctVariantNumberBindable: NSNumber {
        get {
            return NSNumber.init(value: correctVariantNumber)
        }
        set(newValue) {
            correctVariantNumber = newValue.intValue
        }
    }
    
    // Этот текст будет показан, если ответ верный (опционально)
    @objc var correctComment: String?
    // Этот текст будет показан, если ответ неверный (опционально)
    @objc var incorrectComment: String?
    
//    required init(from decoder: Decoder) throws {
//        super.init()
//    }
}

extension QuestionPairsItem: Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let created = QuestionPairsItem()
        return created as! T
    }
}

extension QuestionPairsItem: Expandable {
    var isExpandable: Bool {
        return false
    }
}

extension QuestionPairsItem: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        textField.bind(NSBindingName(rawValue: "value"), to: self, withKeyPath: "correctVariantNumberBindable", options: nil)
    }
}



