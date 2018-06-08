//
//  PrefixValueTransformer.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 08/06/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class PrefixValueTransformer: ValueTransformer {
    var prefix = ""
    
    required init(prefix: String) {
        self.prefix = prefix
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override class func transformedValueClass() -> Swift.AnyClass {
        return NSString.self
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value else {
            return nil
        }
        return "\(prefix)\(value)"
    }
}
