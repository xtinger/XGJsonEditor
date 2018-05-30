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
    @IBOutlet weak var editorContainerView: NSView!
    
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
//                saveData()
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
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        
        let selectedIndex = outlineView.selectedRow
        if let item = outlineView.item(atRow: selectedIndex) {
            selectEditor(item)
        }
    }
    
    func selectEditor(_ item: Any) {
        
        saveData()
        
        for view in editorContainerView.subviews {
            view.removeFromSuperview()
        }
        
        var viewController: NSViewController?

        if let section = item as? Section {
            let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditorSectionVC")) as! EditorSectionVC
            vc.nameTextField.bind(NSBindingName(rawValue: "value"), to: section, withKeyPath: "name", options: nil)
            vc.pathTextField.bind(NSBindingName(rawValue: "value"), to: section, withKeyPath: "path", options: nil)
            viewController = vc
        }
        
        if let topic = item as? Topic {
            let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditorTopicVC")) as! EditorTopicVC
            vc.nameTextField.bind(NSBindingName(rawValue: "value"), to: topic, withKeyPath: "name", options: nil)
            viewController = vc
        }
        
        if let questionChecksVariant = item as? QuestionChecksVariant {
            let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditorQuestionChecksVariantVC")) as! EditorQuestionChecksVariantVC
            vc.model = questionChecksVariant
            viewController = vc
        }
        
        if let vc = viewController {
            editorContainerView.addSubview(vc.view)
            vc.view.addFillSuperviewConstraints()
        }
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
        if let _ = item as? Lesson {
            return 1
        }
        if let test = item as? Test {
            return test.questions.count
        }
        if let questionChecks = item as? QuestionChecks {
            return questionChecks.variants.count
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
        if let lesson = item as? Lesson {
            switch index {
            case 0:
                if let lessonQuickTest = lesson.lessonQuickTest {
                    return lessonQuickTest
                }
            default:
                break
            }
            
        }
        if let questionChecks = item as? QuestionChecks {
            return questionChecks.variants[index]
        }
        if let test = item as? Test {
            return test.questions[index]
        }
        return DateCell() // stub
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
//        if let _ = item as? Question {
//            return false
//        }
        return true
    }
}

extension ViewController: NSOutlineViewDelegate {
    
    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        let cell = (outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DateCell"), owner: self) as? DateCell)!
        
        if let textField = cell.textField {
            if let section = item as? Section{
                textField.bind(NSBindingName(rawValue: "value"), to: section, withKeyPath: "name", options: nil)
//                textField.stringValue = name
            }
            if let topic = item as? Topic{
                textField.bind(NSBindingName(rawValue: "value"), to: topic, withKeyPath: "name", options: nil)
            }
            if let lesson = item as? Lesson{
                textField.bind(NSBindingName(rawValue: "value"), to: lesson, withKeyPath: "name", options: nil)
            }
            if let _ = item as? LessonQuickTest{
                textField.stringValue = "[Вопрос по лекции]"
            }
            if let _ = item as? TopicTest{
                textField.stringValue = "[Тест]"
            }
            if let question = item as? Question, let type = question.type?.rawValue{
//                textField.bind(NSBindingName(rawValue: "value"), to: question, withKeyPath: "type.rawValue", options: nil)
                textField.stringValue = type
            }
            if let questionChecksVariant = item as? QuestionChecksVariant{
                textField.bind(NSBindingName(rawValue: "value"), to: questionChecksVariant, withKeyPath: "text", options: nil)
            }
            return cell
        }
        
        return nil
    }
}

public extension NSView {
    func addFillSuperviewConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let viewsDict = ["view": self]
        self.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        self.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
    }
}



