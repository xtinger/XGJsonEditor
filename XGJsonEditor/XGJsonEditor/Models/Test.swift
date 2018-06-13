//
//  Test.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class Test: NSObject, Codable {
    weak var parent: NSObject?
    
    var id: Int?
    var questions: [Question] = []
    
    enum QuestionsKey: CodingKey {
        case id, questions
    }
    
    enum QuestionTypeKey: String, CodingKey {
        case type = "type"
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: QuestionsKey.self)
        self.id = try container.decode(Int.self, forKey: QuestionsKey.id)
        var arrayForType = try container.nestedUnkeyedContainer(forKey: QuestionsKey.questions)
        var questions = [Question]()
        var questionsArray = arrayForType
        while(!arrayForType.isAtEnd) {
            let question = try arrayForType.nestedContainer(keyedBy: QuestionTypeKey.self)
            let type = try question.decode(QuestionType.self, forKey: QuestionTypeKey.type)
            switch type {
            case .checks:
                questions.append(try questionsArray.decode(QuestionChecks.self))
            case .gaps:
                questions.append(try questionsArray.decode(QuestionGaps.self))
            case .pairs:
                questions.append(try questionsArray.decode(QuestionPairs.self))
            case .input:
                questions.append(try questionsArray.decode(QuestionInput.self))
            }
        }
        self.questions = questions
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: QuestionsKey.self)
        try container.encode(id, forKey: .id)
        var arrayContainer = container.nestedUnkeyedContainer(forKey: .questions)
        try arrayContainer.encode(contentsOf: questions)
//        for question in questions! {
//            if let type = question.type {
//                switch type {
//                case .checks:
//                    arrayContainer.encode(contentsOf: questions)
//                case .gaps:
//                case .pairs:
//                case .input:
//                }
//            }
//
//        }
        
    }
}

extension Test: Expandable {
    var isExpandable: Bool {
        return true
    }
}

extension Test: TreeNodeExpandable {
    var numberOfChildren: Int {
        return questions.count
    }
    
    func childAtIndex(index: Int) -> Any? {
        return questions[index]
    }
}

