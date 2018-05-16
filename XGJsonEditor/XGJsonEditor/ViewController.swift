//
//  ViewController.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    var rootModel : RootModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        outlineView.delegate = self
        outlineView.dataSource = self
        
        outlineView.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func loadData() {
        if let filePath = Bundle.main.path(forResource: "topics", ofType: "json") {
            print("filePath OK")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let root = try decoder.decode(RootModel.self, from: data)
                self.rootModel = root
                print("OK")
                saveData()
            }
            catch {
                print("ERROR")
            }
        }
    }
    
    func saveData() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(rootModel)
//        let string = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
//        print(string)
        
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = URL(string: documentsDirectoryPathString)!
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("test.json")
        let fileManager = FileManager.default
        
//        if !fileManager.fileExists(atPath: jsonFilePath.absoluteString) {
            fileManager.createFile(atPath: jsonFilePath.absoluteString, contents: jsonData, attributes: nil)
//        }
        
    }
}

extension ViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil, let sections = self.rootModel.sections{
            return sections.count
        }
        if let section = item as? Section, let topics = section.topics {
            return topics.count
        }
        if let _ = item as? Topic {
            return 2
        }
        if let test = item as? Test {
            return test.questions?.count ?? 0
        }
        else {
            return 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil, let sections = self.rootModel.sections{
            return sections[index]
        }
        if let section = item as? Section, let topics = section.topics{
            return topics[index]
        }
        if let topic = item as? Topic {
            switch index {
            case 0:
                if let lesson = topic.lesson {
                    return lesson
                }
            case 1:
                if let test = topic.test {
                    return test
                }
            default:
                break
            }
            
        }
        if let test = item as? Test {
            return test.questions?[index] ?? DateCell()
        }
        return DateCell() // stub
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return true
    }
}

extension ViewController: NSOutlineViewDelegate {
    
    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        let cell = (outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DateCell"), owner: self) as? DateCell)!
        
        if let textField = cell.textField {
            if let section = item as? Section, let name = section.name{
                textField.stringValue = name
            }
            if let topic = item as? Topic, let name = topic.name{
                textField.stringValue = name
            }
            if let lesson = item as? Lesson, let name = lesson.name{
                textField.stringValue = name
            }
            if let _ = item as? TopicTest{
                textField.stringValue = "[Тест]"
            }
            if let question = item as? Question, let type = question.type?.rawValue{
                textField.stringValue = type
            }
            return cell
        }
        
        return nil
    }
}

