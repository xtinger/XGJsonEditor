//
//  EditorLesson.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 27/06/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa
import WebKit

class EditorLesson: EditorBaseVC {
    
    weak var lesson: Lesson?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var buttonEdit: NSButton!
    @IBOutlet weak var buttonRefresh: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        buttonEdit.action = #selector(edit(_:))
        buttonEdit.target = self
    }
    

    override func viewDidAppear() {
        super.viewDidAppear()
        load()
    }
    
    func load() {
        if let jsonUrl = UserDefaults.standard.url(forKey: "recentJson"), let lesson = lesson, let path = lesson.path {
            let lessonUrl = jsonUrl.deletingLastPathComponent().appendingPathComponent(path).appendingPathExtension("html")
            print(lessonUrl)
            let request = URLRequest(url: lessonUrl)
            webView.load(request)
        }
    }
    
    @IBAction func edit(_ sender: NSButton) {
        NSWorkspace.shared.activateFileViewerSelecting([webView.url!])
    }
    
    @IBAction func refresh(_ sender: NSButton) {
        load()
    }

}
