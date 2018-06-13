//
//  TreeNodeExpandable.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 13/06/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Foundation

public protocol TreeNodeExpandable {
    var numberOfChildren: Int {get}
    func childAtIndex(index: Int) -> Any?
}
