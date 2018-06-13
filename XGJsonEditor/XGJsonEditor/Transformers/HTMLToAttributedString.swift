//
//  HTMLToAttributedString.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 30/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa
import SwiftSoup

@objc(HTMLToAttributedString)
class HTMLToAttributedString: ValueTransformer {
    
    var showEmptyMessage = false
    static let messageIfEmpty = "(нет текста)"
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> Swift.AnyClass {
        return NSAttributedString.self
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard value != nil else {
            if showEmptyMessage {
                return HTMLToAttributedString.messageIfEmpty
            }
            return nil
        }

        let string: String = value as! String
        
        if string.isEmpty && showEmptyMessage {
            return HTMLToAttributedString.messageIfEmpty
        }
        
        return string.html2Attributed
        
        
        
//        let attrStr = try! NSAttributedString(data: string.data(using: .utf8)!, options: [:], documentAttributes: nil)
//        return attrStr
        

    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard value != nil else {
            return nil
        }
        
        let attrStr: NSAttributedString = value as! NSAttributedString
        
        if attrStr.string.isEmpty {
            print("empty")
        }
        
        let documentAttributes = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
        
        do {
            let htmlData = try attrStr.data(from: NSMakeRange(0, attrStr.length), documentAttributes:documentAttributes)
            if let htmlString = String(data:htmlData, encoding:String.Encoding.utf8) {
                if let bodyHtmlString = try cleanupHtmlString(htmlString: htmlString) {
                    print(bodyHtmlString)
                    return bodyHtmlString
                }
                else {
                    print(htmlString)
                    return htmlString
                }
            }
            else {
                return nil
            }
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func cleanupHtmlString(htmlString: String) throws -> String?{
        let doc: Document = try SwiftSoup.parseBodyFragment(htmlString)
        try doc.body()?.getElementsByTag("meta").remove()
        try doc.body()?.getElementsByTag("style").remove()
        try doc.body()?.getElementsByTag("title").remove()
        try doc.body()?.getElementsByTag("p").removeAttr("class")
        try doc.body()?.getElementsByTag("span").removeAttr("class")
        let bodyHtmlString = try doc.body()?.html()
        return bodyHtmlString
    }
}

extension String {
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
