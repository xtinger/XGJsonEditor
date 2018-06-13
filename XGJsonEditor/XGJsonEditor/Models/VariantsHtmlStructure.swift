//
//  VariantsHtmlStructure.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 07/06/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa
import SwiftSoup

class VariantsStructureTitle: NSObject {
    @objc var text: String
    
    required init(text: String) {
        self.text = text
    }
}

extension VariantsStructureTitle: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        let valueTransformer = EmptyTextTransformer()
        textField.bind(NSBindingName(rawValue: "value"), to: self, withKeyPath: "text", options: [.valueTransformer: valueTransformer])
    }
}

extension VariantsStructureTitle: Expandable {
    var isExpandable: Bool {
        return false
    }
}


class VariantsStructureElement: NSObject {
    @objc var text: String
    
    required init(text: String) {
        self.text = text
    }
}

extension VariantsStructureElement: Expandable {
    var isExpandable: Bool {
        return false
    }
}

extension VariantsStructureElement: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        let valueTransformer = EmptyTextTransformer()
        textField.bind(NSBindingName(rawValue: "value"), to: self, withKeyPath: "text", options: [.valueTransformer: valueTransformer])
    }
}


class VariantsHtmlStructure: NSObject {
    var title: VariantsStructureTitle = VariantsStructureTitle(text:"")
    
    var elements: [VariantsStructureElement] = []
    
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
                    .addClass("pairs_answers_title")
                    .text(title.text)
                let ol = try p?
                    .appendElement("ol")
                    .addClass("pairs_answers")
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
            if let title = try doc.getElementsByClass("pairs_answers_title").first() {
                self.title.text = title.ownText()
            }
            if let questionElements = try doc.getElementsByClass("pairs_answers").first() {
                var makeQuestions: [VariantsStructureElement] = []
                try questionElements.getElementsByTag("li").forEach { (listItem) in
                    let question = VariantsStructureElement(text: listItem.ownText())
                    makeQuestions.append(question)
                }
                self.elements = makeQuestions
            }
        }
        catch {
            
        }
    }
}

extension VariantsHtmlStructure: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        textField.stringValue = "[Оформление вариантов]"
    }
}

extension VariantsHtmlStructure: TreeNodeExpandable {
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

