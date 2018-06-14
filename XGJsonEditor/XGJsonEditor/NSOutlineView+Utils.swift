//
//  NSOutlineView+Utils.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 14/06/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa
import ObjectiveC

extension NSOutlineView {
    
    //* найти объект дерева с типом parentType вверх по иерархии от объекта item *//
    func findParent<T>(of item: Any?, type:T.Type) -> T? {
        
        guard let item = item else {
            return nil
        }
        
        var currentItem: Any? = item
        while let parent = parent(forItem: currentItem)   {
            if let parent = parent as? T {
                return parent
            }
            else {
                currentItem = parent
            }
        }
        
        return nil
    }
    
    func addChild<Item:Equatable & Creatable, Parent:NSObject>(to item:Any, arrayKeyPath: String, itemType: Item.Type, parentType:Parent.Type) {
        
        if let parent = findParent(of: item, type: Parent.self) {
            guard var array = parent.mutableArrayValue(forKeyPath: arrayKeyPath) as? [Item] else {return}
            let newItem = Item.create()
            array.append(newItem)
            parent.setValue(array, forKeyPath: arrayKeyPath)
            
            reloadItem(parent, reloadChildren: true)
            expandItem(array, expandChildren: true)
        }
    }
    
    //* Добавить item типа itemType в массив по пути arrayKeyPath, найти обновить объект дерева с типом parentType *//
    func addAfter<Item:Equatable & Creatable, Parent:NSObject>(item: Any, arrayKeyPath: String, itemType: Item.Type, parentType:Parent.Type) {
        
        if let parent = findParent(of: item, type: Parent.self) {

            guard var array = parent.mutableArrayValue(forKeyPath: arrayKeyPath) as? [Item] else {return}
            guard let item = item as? Item else {return}
            
            let newItem = Item.create()
            if let index = array.index(of: item) {
                let nextIndex = index.advanced(by: 1)
//                print(Unmanaged.passUnretained(array as AnyObject).toOpaque())
                array.insert(newItem, at: nextIndex)
//                print(Unmanaged.passUnretained(array as AnyObject).toOpaque())
                print(array.count)
            }
            else {
                array.append(newItem)
            }
            
            parent.setValue(array, forKeyPath: arrayKeyPath)
            
            reloadItem(parent, reloadChildren: true)
            expandItem(array, expandChildren: true)
        }
    }
    
    //* Добавить item типа itemType в массив array, обновить объект дерева parent *//
    func addAfter<Item:Equatable & Creatable>(item: Any, parent: AnyObject, arrayKeyPath: String, type: Item.Type) {
        
        guard let item = item as? Item else {return}
//        guard let parent = parent else {return}
        guard var array = parent.mutableArrayValue(forKeyPath: arrayKeyPath) as? [Item] else {return}
        
        let newItem = Item.create()
        if let index = array.index(of: item) {
            let nextIndex = index.advanced(by: 1)
            array.insert(newItem, at: nextIndex)
        }
        else {
            array.append(newItem)
        }
        
        parent.setValue(array, forKeyPath: arrayKeyPath)
        
        reloadItem(parent, reloadChildren: true)
        expandItem(array, expandChildren: true)
    }
}
