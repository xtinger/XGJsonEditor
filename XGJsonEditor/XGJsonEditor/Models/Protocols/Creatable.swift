//
//  Creatable.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 13/06/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

public protocol Creatable: class {
    static func create() -> Self
}

public protocol CreatableByType: class {
    static func create<T>(type: T.Type) -> T
}

