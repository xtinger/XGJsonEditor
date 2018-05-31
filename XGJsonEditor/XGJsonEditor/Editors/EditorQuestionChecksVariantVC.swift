//
//  EditorQuestionChecksVariantVC.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 30/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class EditorQuestionChecksVariantVC: EditorBaseVC {
    @objc var text: String?
    
    @objc var model: QuestionChecksVariant? {
        willSet {
            willChangeValue(forKey: "model")
        }
        didSet {
            didChangeValue(forKey: "model")
        }
    }
    
    @IBOutlet var textTextView: NSTextView!
    @IBOutlet var correctCommentTextView: NSTextView!
    @IBOutlet var incorrectCommentTextView: NSTextView!
    
}
