//
//  QuestionFactory.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 13/06/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionFactory: NSObject {
    class func create(type: QuestionType) -> Question {
        var created: Question?
        switch type {
        case .checks :
            created = QuestionChecks.create()
        case .pairs :
            created = QuestionPairs.create()
        case .input :
            created = QuestionInput.create()
        case .gaps :
            created = QuestionGaps.create()
        }
        
        created!.type = type
        return created!
    }
}
