//
//  TreeData.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

// раздел
class Section: NSObject, Codable {
    var id: Int?
    @objc var name: String?
    @objc var path: String?
    var isFree: Bool?
    var topics: [Topic]?
    var sectionTest: SectionTest? {
        didSet {
            sectionTest?.parent = self
        }
    }
}

extension Section: Creatable {
    class func create() -> Self {
        return create(type: self)
    }
    
    class func create<T>(type: T.Type) -> T {
        let section = Section()
        section.id = IDGenerator.generate()
        section.name = ""
        section.path = ""
        section.topics = [Topic.create()]
        section.isFree = false
        section.sectionTest = SectionTest()
        section.sectionTest?.parent = section
        return section as! T
    }
}


