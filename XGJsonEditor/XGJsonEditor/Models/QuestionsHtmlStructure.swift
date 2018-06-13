//
//  ItemsHtmlStructure.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 07/06/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa
import SwiftSoup

class QuestionsStructureTitle: NSObject {
    @objc var text: String
    
    required init(text: String) {
        self.text = text
    }
}

extension QuestionsStructureTitle: Expandable {
    var isExpandable: Bool {
        return false
    }
}

extension QuestionsStructureTitle: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        let valueTransformer = EmptyTextTransformer()
        textField.bind(NSBindingName(rawValue: "value"), to: self, withKeyPath: "text", options: [.valueTransformer: valueTransformer])
    }
}


class QuestionsStructureElement: NSObject {
    @objc var text: String
    
    required init(text: String) {
        self.text = text
    }
}

extension QuestionsStructureElement: Expandable {
    var isExpandable: Bool {
        return false
    }
}

extension QuestionsStructureElement: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        let valueTransformer = EmptyTextTransformer()
        textField.bind(NSBindingName(rawValue: "value"), to: self, withKeyPath: "text", options: [.valueTransformer: valueTransformer])
    }
}


class QuestionsHtmlStructure: NSObject {
    var title: QuestionsStructureTitle = QuestionsStructureTitle(text:"")
    
    var elements: [QuestionsStructureElement] = []
    
    var htmlOutput: String {
        get {
            do {
                if title.text.isEmpty {
                    return ""
                }

                let doc: Document = try! SwiftSoup.parseBodyFragment("")
                let p = try doc
                    .body()?
                    .appendElement("p")
                    .addClass("pairs_questions_title")
                    .text(title.text)
                let ol = try p?
                    .appendElement("ol")
                    .addClass("pairs_questions")
                try elements.forEach { (question) in
                    try ol?.appendElement("li").text(question.text)
                }
                if let p = p {
                    return try p.html()
                }
                else {
                    return ""
                }
            }
            catch {
                return ""
            }
        }
    }
    
    required init(html: String) {
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            if let title = try doc.getElementsByClass("pairs_questions_title").first() {
                self.title.text = title.ownText()
            }
            if let questionElements = try doc.getElementsByClass("pairs_questions").first() {
                var makeQuestions: [QuestionsStructureElement] = []
                try questionElements.getElementsByTag("li").forEach { (listItem) in
                    let question = QuestionsStructureElement(text: listItem.ownText())
                    makeQuestions.append(question)
                }
                self.elements = makeQuestions
            }
        }
        catch {
            
        }
    }
    
    
}

extension QuestionsHtmlStructure: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        textField.stringValue = "[Оформление вопроса]"
    }
}

extension QuestionsHtmlStructure: TreeNodeExpandable {
    var numberOfChildren: Int {
        return 2
    }
    
    func childAtIndex(index: Int) -> Any? {
        switch index {
        case 0:
            return title
        case 1:
            return elements
        default:
            break
        }
        return nil
    }
}

