//
//  ViewController.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let treeController = NSTreeController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        treeController.content = []
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

