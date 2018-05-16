//
//  TreeData.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

// раздел
class Section: NSObject {
    var id: Int?
    var name: String?
    var path: String?
    var isFree: Bool?
    var topics: [Topic]?
    var sectionTest: SectionTest?
}
