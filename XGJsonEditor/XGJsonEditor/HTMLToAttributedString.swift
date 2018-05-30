//
//  HTMLToAttributedString.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 30/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

@objc(HTMLToAttributedString)
class HTMLToAttributedString: ValueTransformer {
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard value != nil else {
            return nil
        }

        let string: String = value as! String
        return string.html2Attributed
        
//        let attrStr = try! NSAttributedString(data: string.data(using: .utf8)!, options: [:], documentAttributes: nil)
//        return attrStr
        

    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard value != nil else {
            return nil
        }
        
        let attrStr: NSAttributedString = value as! NSAttributedString
        return attrStr.string
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
