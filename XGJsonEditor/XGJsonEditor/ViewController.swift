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
    
    @IBOutlet weak var buttonAdd: NSButton!
    @IBOutlet weak var addQuestionPopupButton: NSPopUpButton!
    
    
    var rootModel : RootModel!
    var treeRoot : NSObject!
    var documents: NSDocumentController = NSDocumentController()
    var questionTypes: [String] = [" + ", "checks", "gaps", "pairs", "input"]
    
    var selectedQuestionType: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "EGEClient editor"

//        loadData()
        outlineView.delegate = self
        outlineView.dataSource = self
        resetButtons()
        
        addQuestionPopupButton.removeAllItems()
        addQuestionPopupButton.addItems(withTitles: questionTypes)
        
        
        
        if let url = UserDefaults.standard.url(forKey: "recentJson") {
            loadData(url: url)
        }
        
//        NSDocumentController.shared.openDocument(self)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func openDocument(_ sender: Any?) {
        
        let dialog = NSOpenPanel()
        
        let launcherLogPathWithTilde = "~/Documents" as NSString
        let expandedLauncherLogPath = launcherLogPathWithTilde.expandingTildeInPath
        dialog.directoryURL = NSURL.fileURL(withPath: expandedLauncherLogPath, isDirectory: true)
        
        dialog.title                   = "Choose a .json file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["json"]
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            if let result = dialog.url {
                loadData(url: result)
            }
        }
    }

    func loadData(url: URL) {
        //if let filePath = Bundle.main.path(forResource: "topics", ofType: "json") {
        
//        print("filePath OK")
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let root = try decoder.decode(RootModel.self, from: data)
            self.rootModel = root
//            self.treeRoot = root.sections!.first!.topics!.first!.test?.questions[1]
            self.treeRoot = root
            print("OK")
            
            UserDefaults.standard.set(url, forKey: "recentJson")
            
            outlineView.reloadData()
            
            //                saveData()
        }
        catch {
            print(error)
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
            setupActions(item)
        }
    }
    
    func resetButtons() {
        buttonAdd.isHidden = true
        addQuestionPopupButton.isHidden = true
    }
    
    func setupActions(_ item: Any) {
        resetButtons()

        if let _ = item as? Section {
            buttonAdd.isHidden = false
        }
        
        if let _ = item as? Test {
//            buttonCheck.isHidden = false
//            buttonGap.isHidden = false
//            buttonInput.isHidden = false
//            buttonPairs.isHidden = false
            addQuestionPopupButton.isHidden = false
        }
        
        if let _ = item as? Question {
//            buttonCheck.isHidden = false
//            buttonGap.isHidden = false
//            buttonInput.isHidden = false
//            buttonPairs.isHidden = false
            addQuestionPopupButton.isHidden = false
        }
        
        if let _ = item as? QuestionChecks {
            buttonAdd.isHidden = false
        }
    }
    
    @IBAction func buttonAddClicked(_ sender: Any) {
        let possibleItem = outlineView.item(atRow: outlineView.selectedRow)
        guard let item = possibleItem else {return}
        let parent = outlineView.parent(forItem: item)
        
        switch item {
        case let section as Section:
            let index = rootModel.sections?.index(of: section)
            let newSection = Section.create()
            let nextIndex = index!.advanced(by: 1)
            rootModel.sections?.insert(newSection, at: nextIndex)
            outlineView.reloadItem(parent)
            
            let indexSet = IndexSet.init(integer: nextIndex)
            outlineView.selectRowIndexes(indexSet, byExtendingSelection: false)
        case let checks as QuestionChecks:
            let newVariant = QuestionChecksVariant.create()
            checks.variants.append(newVariant)
            outlineView.reloadItem(checks, reloadChildren: true)
        default:
            return
        }
    }
        
        

    @IBAction func addQuestionTouched(_ sender: Any) {
        let popup: NSPopUpButton = sender as! NSPopUpButton
        let index = popup.indexOfSelectedItem
        
        switch index {
        case 1:
            createQuestion(questionType: .checks)
        case 2:
            createQuestion(questionType: .gaps)
        case 3:
            createQuestion(questionType: .pairs)
        case 4:
            createQuestion(questionType: .input)
        default:
            return
        }
        
        popup.selectItem(at: 0)
    }

    func createQuestion(questionType: QuestionType) {
        let possibleItem = outlineView.item(atRow: outlineView.selectedRow)
        guard let item = possibleItem else {return}
        let parent = outlineView.parent(forItem: item)
        
        var parentTest: Test?
        var questions: Array<Question>?
        var index: Int?
        
        if let test = item as? Test {
            parentTest = test
            questions = test.questions
        }
        
        if let question = item as? Question, let test = parent as? Test {
            parentTest = test
            questions = test.questions
            let questions = test.questions
            index = questions.index(of: question)
        }
        
        if var questions = questions, let test = parentTest {
            let newQuestion = QuestionFactory.create(type: questionType)
            if let index = index {
                questions.insert(newQuestion, at: index.advanced(by: 1))
            }
            else {
                questions.append(newQuestion)
            }
            test.questions = questions
            
            outlineView.reloadItem(test, reloadChildren: true)
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
        
        if let questionChecks = item as? QuestionChecks {
            let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditorQuestionChecksVC")) as! EditorQuestionChecksVC
            
            let valueTransformer = HTMLToAttributedString()
            vc.textView.bind(NSBindingName(rawValue: "attributedString"), to: questionChecks, withKeyPath: "text", options: [.valueTransformer: valueTransformer])
            
            viewController = vc
        }
        
        if let questionChecksVariant = item as? QuestionChecksVariant {
            let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditorQuestionChecksVariantVC")) as! EditorQuestionChecksVariantVC
//            vc.text = questionChecksVariant.text
//            vc.model = questionChecksVariant
            let valueTransformer = HTMLToAttributedString()
            
            vc.textTextView.bind(NSBindingName(rawValue: "attributedString"), to: questionChecksVariant, withKeyPath: "text", options: [.valueTransformer: valueTransformer])
            vc.isCorrectCheckBox.bind(NSBindingName(rawValue: "value"), to: questionChecksVariant, withKeyPath: "isCorrect", options: nil)
            vc.correctCommentTextView.bind(NSBindingName(rawValue: "attributedString"), to: questionChecksVariant, withKeyPath: "correctComment", options: [.valueTransformer: valueTransformer])
            vc.incorrectCommentTextView.bind(NSBindingName(rawValue: "attributedString"), to: questionChecksVariant, withKeyPath: "incorrectComment", options: [.valueTransformer: valueTransformer])
            
            viewController = vc
        }
        
        if let questionChecks = item as? QuestionGaps {
            let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditorQuestionGapsVC")) as! EditorQuestionGapsVC
            
            let valueTransformer = HTMLToAttributedString()
            vc.textView.bind(NSBindingName(rawValue: "attributedString"), to: questionChecks, withKeyPath: "text", options: [.valueTransformer: valueTransformer])
            
            viewController = vc
        }
        
        if let questionChecksVariant = item as? QuestionGapsVariant {
            let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditorQuestionGapsVariantVC")) as! EditorQuestionGapsVariantVC
            let valueTransformer = HTMLToAttributedString()
            
            vc.textView.bind(NSBindingName(rawValue: "attributedString"), to: questionChecksVariant, withKeyPath: "text", options: [.valueTransformer: valueTransformer])
            
            viewController = vc
        }
        
        if let questionGapsItem = item as? QuestionGapsItem {
            let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditorQuestionGapsItemVC")) as! EditorQuestionGapsItemVC
            let valueTransformer = HTMLToAttributedString()
            
            vc.numberTextField.bind(NSBindingName(rawValue: "value"), to: questionGapsItem, withKeyPath: "correctVariantNumberBindable", options: nil)
            vc.correctCommentTextView.bind(NSBindingName(rawValue: "attributedString"), to: questionGapsItem, withKeyPath: "correctComment", options: [.valueTransformer: valueTransformer])
            vc.incorrectCommentTextView.bind(NSBindingName(rawValue: "attributedString"), to: questionGapsItem, withKeyPath: "incorrectComment", options: [.valueTransformer: valueTransformer])
            
            viewController = vc
        }
        
        if let questionPairsItem = item as? QuestionPairsItem {
            let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditorQuestionGapsItemVC")) as! EditorQuestionGapsItemVC
            
            let valueTransformer = HTMLToAttributedString()
            vc.numberTextField.bind(NSBindingName(rawValue: "value"), to: questionPairsItem, withKeyPath: "correctVariantNumberBindable", options: nil)
            vc.correctCommentTextView.bind(NSBindingName(rawValue: "attributedString"), to: questionPairsItem, withKeyPath: "correctComment", options: [.valueTransformer: valueTransformer])
            vc.incorrectCommentTextView.bind(NSBindingName(rawValue: "attributedString"), to: questionPairsItem, withKeyPath: "incorrectComment", options: [.valueTransformer: valueTransformer])
            
            viewController = vc
        }
        
        if let questionPairs = item as? QuestionPairs {
            viewController = ViewController.makeSingleTextViewEditor(title: "Текст вопроса:", bindingModel: questionPairs, withKeyPath: "text")
        }
        if let question = item as? QuestionsStructureElement {
            viewController = ViewController.makeSingleTextFieldEditor(title: "Текст:", bindingModel: question, withKeyPath: "text")
        }
        if let questionsStructureTitle = item as? QuestionsStructureTitle {
            viewController = ViewController.makeSingleTextFieldEditor(title: "Текст:", bindingModel: questionsStructureTitle, withKeyPath: "text")
        }
        if let variantsStructureTitle = item as? VariantsStructureTitle {
            viewController = ViewController.makeSingleTextFieldEditor(title: "Текст:", bindingModel: variantsStructureTitle, withKeyPath: "text")
        }
        if let question = item as? VariantsStructureElement {
            viewController = ViewController.makeSingleTextFieldEditor(title: "Текст:", bindingModel: question, withKeyPath: "text")
        }
        if let questionPairsVariant = item as? QuestionPairsVariant {
            viewController = ViewController.makeSingleTextFieldEditor(title: "Текст:", bindingModel: questionPairsVariant, withKeyPath: "text")
        }
        
        if let questionInput = item as? QuestionInput {
            let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditorQuestionInput")) as! EditorQuestionInput
            
            let valueTransformer = HTMLToAttributedString()
            vc.questionTextView.bind(NSBindingName(rawValue: "attributedString"), to: questionInput, withKeyPath: "html", options: [.valueTransformer: valueTransformer])
            vc.answerTextField.bind(NSBindingName(rawValue: "value"), to: questionInput, withKeyPath: "correctAnswer", options: nil)
            vc.correctCommentTextView.bind(NSBindingName(rawValue: "attributedString"), to: questionInput, withKeyPath: "correctComment", options: [.valueTransformer: valueTransformer])
            vc.incorrectCommentTextView.bind(NSBindingName(rawValue: "attributedString"), to: questionInput, withKeyPath: "incorrectComment", options: [.valueTransformer: valueTransformer])
            
            viewController = vc
        }

        if let vc = viewController {
            editorContainerView.addSubview(vc.view)
            vc.view.addFillSuperviewConstraints()
        }
    }
    
    static func makeSingleTextFieldEditor(title: String, bindingModel model: Any, withKeyPath keyPath: String) -> NSViewController {
        let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "SingleTextFieldEditor")) as! SingleTextFieldEditor
        vc.textField.bind(NSBindingName(rawValue: "value"), to: model, withKeyPath: keyPath, options: nil)
        vc.titleTextField.stringValue = title
        return vc
    }
    
    static func makeSingleTextViewEditor(title: String, bindingModel model: Any, withKeyPath keyPath: String) -> NSViewController {
        let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "SingleTextViewEditor")) as! SingleTextViewEditor
        vc.textView.bind(NSBindingName(rawValue: "attributedString"), to: model, withKeyPath: keyPath, options: nil)
        vc.titleTextField.stringValue = title
        return vc
    }
}

extension ViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard self.rootModel != nil else {
            return 0
        }
        
        if item == nil {
            if let array = self.treeRoot as? Array<Any> {
                return array.count
            }
            if let root = self.treeRoot as? RootModel {
                return root.sections!.count
            }
            return 1
        }
        
//        if item == nil, let sections = self.rootModel.sections{
//            return sections.count
//        }
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
        if let _ = item as? QuestionGaps {
            return 2
        }
        if let _ = item as? QuestionPairs {
            return 4
        }
        if let _ = item as? QuestionsHtmlStructure {
            return 2
        }
        if let _ = item as? VariantsHtmlStructure {
            return 2
        }
        if let array = item as? Array<Any> {
            return array.count
        }
        else {
            return 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            if let array = self.treeRoot as? Array<Any> {
                return array[index]
            }
            if let root = self.treeRoot as? RootModel {
                return root.sections![index]
            }
            return self.treeRoot
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
        if let questionGaps = item as? QuestionGaps {
            switch index {
            case 0:
                if let variants = questionGaps.variants {
                    return variants
                }
            case 1:
                if let items = questionGaps.items {
                    return items
                }
            default:
                break
            }
        }
        if let questionPairs = item as? QuestionPairs {
            switch index {
            case 0:
                return questionPairs.itemsHtmlStructure
            case 1:
                if let items = questionPairs.items {
                    return items
                }
            case 2:
                return questionPairs.variantHtmlStructure
            case 3:
                if let variants = questionPairs.variants {
                    return variants
                }
            default:
                break
            }
        }
        if let questionsHtmlStructure = item as? QuestionsHtmlStructure {
            switch index {
            case 0:
                return questionsHtmlStructure.title
            case 1:
                return questionsHtmlStructure.elements
            default:
                break
            }
        }
        if let variantsHtmlStructure = item as? VariantsHtmlStructure {
            switch index {
            case 0:
                return variantsHtmlStructure.title
            case 1:
                return variantsHtmlStructure.elements
            default:
                break
            }
        }
        if let array = item as? Array<Any> {
            return array[index]
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
                let valueTransformer = PrefixValueTransformer(prefix: "РАЗДЕЛ:")
                textField.bind(NSBindingName(rawValue: "value"), to: section, withKeyPath: "name", options: [.valueTransformer: valueTransformer])
//                textField.stringValue = name
            }
            else if let topic = item as? Topic{
                let valueTransformer = PrefixValueTransformer(prefix: "ТЕМА:")
                textField.bind(NSBindingName(rawValue: "value"), to: topic, withKeyPath: "name", options: [.valueTransformer: valueTransformer])
            }
            else if let lesson = item as? Lesson{
                let valueTransformer = PrefixValueTransformer(prefix: "ЛЕКЦИЯ:")
                textField.bind(NSBindingName(rawValue: "value"), to: lesson, withKeyPath: "name", options: [.valueTransformer: valueTransformer])
            }
            else if let _ = item as? LessonQuickTest{
                textField.stringValue = "[Вопрос по лекции]"
            }
            else if let _ = item as? TopicTest{
                textField.stringValue = "[Тест]"
            }
            else if let question = item as? Question, let type = question.type?.rawValue{
//                textField.bind(NSBindingName(rawValue: "value"), to: question, withKeyPath: "type.rawValue", options: nil)
                textField.stringValue = type
            }
            else if let questionChecksVariant = item as? QuestionChecksVariant {
                let valueTransformer = HTMLToAttributedString()
                textField.bind(NSBindingName(rawValue: "value"), to: questionChecksVariant, withKeyPath: "text", options: [.valueTransformer: valueTransformer])
//                textField.bind(NSBindingName(rawValue: "value"), to: questionChecksVariant, withKeyPath: "text", options: nil)
            }
            else if let _ = item as? [QuestionGapsVariant] {
                textField.stringValue = "[Варианты ответов]"
            }
            else if let _ = item as? [QuestionGapsItem] {
                textField.stringValue = "[Ответы]"
            }
            else if let questionGapsVariant = item as? QuestionGapsVariant {
                let valueTransformer = HTMLToAttributedString()
                textField.bind(NSBindingName(rawValue: "value"), to: questionGapsVariant, withKeyPath: "text", options: [.valueTransformer: valueTransformer])
            }
            else if let questionGapsItem = item as? QuestionGapsItem {
                let valueTransformer = HTMLToAttributedString()
                textField.bind(NSBindingName(rawValue: "value"), to: questionGapsItem, withKeyPath: "correctComment", options: [.valueTransformer: valueTransformer])
            }
            else if let _ = item as? QuestionsHtmlStructure {
                textField.stringValue = "[Оформление вопроса]"
//                textField.bind(NSBindingName(rawValue: "value"), to: structure, withKeyPath: "title", options: nil)
            }
            else if let _ = item as? VariantsHtmlStructure {
                textField.stringValue = "[Оформление вариантов]"
//                textField.bind(NSBindingName(rawValue: "value"), to: structure, withKeyPath: "title", options: nil)
            }
            else if let title = item as? QuestionsStructureTitle {
                textField.bind(NSBindingName(rawValue: "value"), to: title, withKeyPath: "text", options: nil)
            }
            else if let title = item as? VariantsStructureTitle {
                textField.bind(NSBindingName(rawValue: "value"), to: title, withKeyPath: "text", options: nil)
            }
            else if let question = item as? QuestionsStructureElement {
                textField.bind(NSBindingName(rawValue: "value"), to: question, withKeyPath: "text", options: nil)
            }
            else if let question = item as? VariantsStructureElement {
                textField.bind(NSBindingName(rawValue: "value"), to: question, withKeyPath: "text", options: nil)
            }
            else if let _ = item as? [QuestionPairsItem] {
                textField.stringValue = "[Вопросы]"
            }
            else if let item = item as? QuestionPairsItem {
                textField.bind(NSBindingName(rawValue: "value"), to: item, withKeyPath: "correctVariantNumberBindable", options: nil)
            }
            else if let _ = item as? [QuestionsStructureElement] {
                textField.stringValue = "[Оформление вопроса]"
            }
            else if let _ = item as? [VariantsStructureElement] {
                textField.stringValue = "[Оформление вариантов]"
            }
            else if let _ = item as? [QuestionPairsVariant] {
                textField.stringValue = "[Варианты]"
            }
            else if let variant = item as? QuestionPairsVariant {
                textField.bind(NSBindingName(rawValue: "value"), to: variant, withKeyPath: "text", options: nil)
            }
            else {
                textField.stringValue = String(describing: item)
            }
            return cell
        }
        
        return nil
    }
    
    public func outlineView(_ outlineView: NSOutlineView, didClick tableColumn: NSTableColumn) {
        
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



