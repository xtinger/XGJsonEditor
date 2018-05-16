//
//  QuestionGapsVariant.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionGapsVariant: NSObject, Decodable {
    var text: String?
    
    required init(from decoder: Decoder) throws {
        super.init()
    }
}
