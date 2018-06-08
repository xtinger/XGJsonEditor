//
//  QuestionGapsItem.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionGapsItem: NSObject, Codable {
    
    var correctVariantNumber: Int = 0
    @objc var correctVariantNumberBindable: NSNumber {
        get {
            return NSNumber.init(value: correctVariantNumber)
        }
        set(newValue) {
            correctVariantNumber = newValue.intValue
        }
    }

    @objc var correctComment: String?
    @objc var incorrectComment: String?
    
//    required init(from decoder: Decoder) throws {
//        super.init()
//    }
}
