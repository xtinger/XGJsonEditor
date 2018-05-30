//
//  EditorBaseVC.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 30/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class EditorBaseVC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
    }
    
    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = NSColor.white.cgColor
            self.view.layer?.backgroundColor = color
        }
    }

}
