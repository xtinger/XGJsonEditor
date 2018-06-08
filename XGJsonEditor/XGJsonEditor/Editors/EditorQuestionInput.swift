//
//  EditorQuestionInput.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 08/06/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class EditorQuestionInput: EditorBaseVC {

    @IBOutlet var questionTextView: NSTextView!
    @IBOutlet weak var answerTextField: NSTextField!
    @IBOutlet var correctCommentTextView: NSTextView!
    @IBOutlet var incorrectCommentTextView: NSTextView!
    
}
