//
//  ItemsHtmlStructure.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 07/06/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa
import SwiftSoup

class ItemsHtmlStructure: NSObject {
    var title: String = ""
    var questions: [String] = []
    
    var htmlOutput: String {
        get {
            do {
                if title.isEmpty {
                    return ""
                }

                let doc: Document = try! SwiftSoup.parseBodyFragment("")
                let p = try doc
                    .body()?
                    .appendElement("p")
                    .addClass("pairs_questions_title")
                    .text(title)
                let ol = try p?
                    .appendElement("ol")
                    .addClass("pairs_questions")
                try questions.forEach { (item) in
                    try ol?.appendElement("li").text(item)
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
                self.title = title.ownText()
            }
            if let questionElements = try doc.getElementsByClass("pairs_questions").first() {
                var makeQuestions: [String] = []
                try questionElements.getElementsByTag("li").forEach { (listItem) in
                    makeQuestions.append(listItem.ownText())
                }
                self.questions = makeQuestions
            }
        }
        catch {
            
        }
    }
    
    
}
