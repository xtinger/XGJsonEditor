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
    
    @IBOutlet weak var pathTextField: NSTextField!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var buttonEdit: NSButton!
    @IBOutlet weak var buttonRefresh: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        buttonEdit.action = #selector(edit)
        buttonEdit.target = self
    }
    

    override func viewDidAppear() {
//        super.viewDidAppear()
        load()
    }
    
    func load() {
        if let jsonUrl = UserDefaults.standard.url(forKey: "recentJson"), let lesson = lesson, let path = lesson.path {
            let lessonUrl = jsonUrl.deletingLastPathComponent().appendingPathComponent(path).appendingPathExtension("html")
            print(lessonUrl)
            do {
                let data = try Data(contentsOf: lessonUrl)
                webView.load(data, mimeType: "text/html", characterEncodingName: "utf8", baseURL: NSURL(string: "")! as URL)
            } catch {
                
            }
            //            let request = URLRequest(url: lessonUrl)
            //            webView.load(request)
        }
    }
    
    @IBAction func open(_ sender: Any) {
        let dialog = NSOpenPanel()
        
        guard let lesson = lesson else {return}
        
        if let jsonUrl = UserDefaults.standard.url(forKey: "recentJson") {
            let path = jsonUrl.deletingLastPathComponent().absoluteString
            dialog.directoryURL = NSURL.fileURL(withPath: path, isDirectory: true)
        }
        else {
            let launcherLogPathWithTilde = "~/Documents" as NSString
            let expandedLauncherLogPath = launcherLogPathWithTilde.expandingTildeInPath
            dialog.directoryURL = NSURL.fileURL(withPath: expandedLauncherLogPath, isDirectory: true)
        }
        
        dialog.title                   = "Choose an .html file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["html"]
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            if let resultUrl = dialog.url {
                if let jsonUrl = UserDefaults.standard.url(forKey: "recentJson") {
                    let rootUrl = jsonUrl.deletingLastPathComponent()
                    
                    if resultUrl.absoluteString.hasPrefix(rootUrl.absoluteString) {
                        var rel = resultUrl.absoluteString.replacingOccurrences(of: rootUrl.absoluteString, with: "")
                        if rel.hasSuffix(".html") {
                            rel.removeLast(5)
                        }
                        lesson.path = rel
                        pathTextField.stringValue = rel
                        
                        load()
                    }
                
                }
                
            }
        }
    }
    
    @objc func edit() {
        
        if let root = UserDefaults.standard.url(forKey: "recentJson") {
            var root1 = root.deletingLastPathComponent().absoluteString
            root1.removeFirst(7)
            
            if let path = lesson?.path, !path.isEmpty {
                
                let path1 = "\(path).html"
                //            NSWorkspace.shared.selectFile(path1, inFileViewerRootedAtPath: root1)
                let fullPath = "\(root1)\(path1)"
                NSWorkspace.shared.selectFile(fullPath, inFileViewerRootedAtPath: "")
            }
            else {
                NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: root1)
            }
        }

    }
    
//    @IBAction @objc func edit(_ sender: AnyObject) {
//        NSWorkspace.shared.activateFileViewerSelecting([webView.url!])
        
//        NSWorkspace.shared.selectFile(webView.url?.absoluteString, inFileViewerRootedAtPath: "")
//    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        load()
    }

}
