//
//  EmptyTextTransformer.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 13/06/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class EmptyTextTransformer: ValueTransformer {
    static let message = "(нет текста)"
    
    override init() {
        super.init()
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override class func transformedValueClass() -> Swift.AnyClass {
        return NSString.self
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        if let stringValue = value as? String {
            if stringValue.isEmpty {
                return EmptyTextTransformer.message
            }
            else {
                return value
            }
        }
        else {
            return value
        }
    }
}
