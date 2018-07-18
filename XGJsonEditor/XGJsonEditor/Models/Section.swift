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
    @objc var topics: [Topic]?
    @objc var sectionTest: SectionTest? {
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
        section.sectionTest = SectionTest.create()
        section.sectionTest?.parent = section
        return section as! T
    }
}

extension Section: Expandable {
    var isExpandable: Bool {
        return true
    }
}

extension Section: TextFieldPresentable {
    func setupTextField(textField: NSTextField) {
        let valueTransformer = PrefixValueTransformer(prefix: "РАЗДЕЛ:")
        textField.bind(NSBindingName(rawValue: "value"), to: self, withKeyPath: "name", options: [.valueTransformer: valueTransformer])
    }
}

extension Section: TreeNodeExpandable {
    var numberOfChildren: Int {
        if let topics = self.topics {
            return topics.count
        }
        return 0
    }
    
    func childAtIndex(index: Int) -> Any? {
        if let topics = topics{
            return topics[index]
        }
        return nil
    }
}

