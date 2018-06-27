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
    @IBOutlet weak var buttonDelete: NSButton!
    
    
    var rootModel : RootModel!
    var treeRoot : NSObject!
    var documents: NSDocumentController = NSDocumentController()
    var questionTypes: [String] = [" + вопрос ", "checks", "gaps", "pairs", "input"]
    
    var selectedQuestionType: Any?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.window?.title = "EGEClient editor"
        
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
            
//            self.treeRoot = root.sections!.first!.topics!.first!.test!
            //            self.treeRoot = root.sections!.first!.topics!.first!.test?.questions[1]
                        self.treeRoot = root
//            self.treeRoot = root.sections!.first!.topics![2].test?.questions[2]
            
            print("OK")
            
            UserDefaults.standard.set(url, forKey: "recentJson")
            
            outlineView.reloadData()
            
            outlineView.select(item: root.sections!.first!)
            
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
        buttonDelete.isHidden = true
    }
    
    func setupActions(_ item: Any) {
        
        resetButtons()
        
        if let _ = item as? Section {
            buttonAdd.title = "+ раздел"
            buttonAdd.isHidden = false
            buttonDelete.isHidden = false
        }
        
        if let _ = item as? Topic {
            buttonAdd.title = "+ тема"
            buttonAdd.isHidden = false
            buttonDelete.isHidden = false
        }
        
        if let _ = item as? Test {
            addQuestionPopupButton.isHidden = false
        }
        
        if let _ = item as? Question {
            addQuestionPopupButton.isHidden = false
            buttonDelete.isHidden = false
        }
        
        if let _ = item as? QuestionChecks {
            buttonAdd.title = "+ вариант"
            buttonAdd.isHidden = false
        }
        
        if let _ = item as? QuestionChecksVariant {
            buttonAdd.title = "+ вариант"
            buttonAdd.isHidden = false
            buttonDelete.isHidden = false
        }
        
        if let _ = item as? QuestionGapsVariant {
            buttonAdd.title = "+ вариант"
            buttonAdd.isHidden = false
            buttonDelete.isHidden = false
        }
        
        if let _ = item as? [QuestionGapsVariant] {
            buttonAdd.title = "+ вариант"
            buttonAdd.isHidden = false
        }
        
        if let _ = item as? QuestionGapsItem {
            buttonAdd.title = "+ ответ"
            buttonAdd.isHidden = false
            buttonDelete.isHidden = false
        }
        
        if let _ = item as? [QuestionGapsItem] {
            buttonAdd.title = "+ ответ"
            buttonAdd.isHidden = false
        }
        
        if let _ = item as? QuestionPairsItem {
            buttonAdd.title = "+ вопрос"
            buttonAdd.isHidden = false
            buttonDelete.isHidden = false
        }
        
        if let _ = item as? [QuestionPairsItem] {
            buttonAdd.title = "+ вопрос"
            buttonAdd.isHidden = false
        }
        
        if let _ = item as? QuestionPairsVariant {
            buttonAdd.title = "+ вариант"
            buttonAdd.isHidden = false
            buttonDelete.isHidden = false
        }
        
        if let _ = item as? [QuestionPairsVariant] {
            buttonAdd.title = "+ вариант"
            buttonAdd.isHidden = false
        }
        
        if let _ = item as? [QuestionsStructureElement] {
            buttonAdd.title = "+ оф. вопр."
            buttonAdd.isHidden = false
            buttonDelete.isHidden = false
        }
        
        if let _ = item as? QuestionsStructureElement {
            buttonAdd.title = "+ оф. вопр."
            buttonAdd.isHidden = false
            buttonDelete.isHidden = false
        }
        
        if let _ = item as? [VariantsStructureElement] {
            buttonAdd.title = "+ оф. вар."
            buttonAdd.isHidden = false
            buttonDelete.isHidden = false
        }
        
        if let _ = item as? VariantsStructureElement {
            buttonAdd.title = "+ оф. вар."
            buttonAdd.isHidden = false
            buttonDelete.isHidden = false
        }
    }
    
    @IBAction func buttonAddClicked(_ sender: Any) {
        
        let possibleItem = outlineView.item(atRow: outlineView.selectedRow)
        let parent = outlineView.parent(forItem: possibleItem)
        
        
//        if parent == nil {
//            outlineView.addAfter(item: nil, parent: rootModel, arrayKeyPath: "sections", type: Section.self)
//            outlineView.reloadItem(parent)
//        }
        
        guard let item = possibleItem else {return}
        
        switch item {
            
        case let section as Section:

            outlineView.addAfter(item: section, parent: rootModel, arrayKeyPath: "sections", type: Section.self)
            outlineView.reloadItem(parent)
            
        case let topic as Topic:
            
            outlineView.addAfter(item: topic, arrayKeyPath: "topics", itemType: Topic.self, parentType: Section.self)

        case let checks as QuestionChecks:
            
            let newVariant = QuestionChecksVariant.create()
            checks.variants.append(newVariant)
            outlineView.reloadItem(checks, reloadChildren: true)
            
        case let checksVariant as QuestionChecksVariant:
            
            outlineView.addAfter(item: checksVariant, arrayKeyPath: "variants", itemType: QuestionChecksVariant.self, parentType: QuestionChecks.self)

        case let gapsVariant as QuestionGapsVariant:
            
            outlineView.addAfter(item: gapsVariant, arrayKeyPath: "variants", itemType: QuestionGapsVariant.self, parentType: QuestionGaps.self)

        case let gapsVariants as [QuestionGapsVariant]:
            
            outlineView.addChild(to: gapsVariants, arrayKeyPath: "variants", itemType: QuestionGapsVariant.self, parentType: QuestionGaps.self)
            
        case let gapsItem as QuestionGapsItem:
            
            outlineView.addAfter(item: gapsItem, arrayKeyPath: "items", itemType: QuestionGapsItem.self, parentType: QuestionGaps.self)

        case let gapsItems as [QuestionGapsItem]:
            
            outlineView.addChild(to: gapsItems, arrayKeyPath: "items", itemType: QuestionGapsItem.self, parentType: QuestionGaps.self)
            
        case let pairsItem as QuestionPairsItem:
            
            outlineView.addAfter(item: pairsItem, arrayKeyPath: "items", itemType: QuestionPairsItem.self, parentType: QuestionPairs.self)

        case let questionPairItems as [QuestionPairsItem]:
            
            outlineView.addChild(to: questionPairItems, arrayKeyPath: "items", itemType: QuestionPairsItem.self, parentType: QuestionPairs.self)
            
        case let pairsVariant as QuestionPairsVariant:
            
            outlineView.addAfter(item: pairsVariant, arrayKeyPath: "variants", itemType: QuestionPairsVariant.self, parentType: QuestionPairs.self)
            
        case let questionPairVariants as [QuestionPairsVariant]:
            
            outlineView.addChild(to: questionPairVariants, arrayKeyPath: "variants", itemType: QuestionPairsVariant.self, parentType: QuestionPairs.self)
            
        case let itemsElement as QuestionsStructureElement:
            
            outlineView.addAfter(item: itemsElement, arrayKeyPath: "itemsHtmlStructure.elements", itemType: QuestionsStructureElement.self, parentType: QuestionPairs.self)
            
        case let questionsStructureElements as [QuestionsStructureElement]:
            
            outlineView.addChild(to: questionsStructureElements, arrayKeyPath: "itemsHtmlStructure.elements", itemType: QuestionsStructureElement.self, parentType: QuestionPairs.self)

        case let itemsElement as VariantsStructureElement:
            
            outlineView.addAfter(item: itemsElement, arrayKeyPath: "variantHtmlStructure.elements", itemType: VariantsStructureElement.self, parentType: QuestionPairs.self)
            
        case let variantsStructureElement as [VariantsStructureElement]:
            
            outlineView.addChild(to: variantsStructureElement, arrayKeyPath: "variantHtmlStructure.elements", itemType: VariantsStructureElement.self, parentType: QuestionPairs.self)

        default:
            return
        }
    }
    
    @IBAction func buttonDeleteClicked(_ sender: Any) {
        let possibleItem = outlineView.item(atRow: outlineView.selectedRow)
        guard let item = possibleItem else {return}
        let parent = outlineView.parent(forItem: item) ?? rootModel
        
        switch item {
            
        case let section as Section:
            
            if (rootModel.sections!.count == 1) {
                print("Нельзя удалять единственный элемент!")
                break
            }
            
            if let index = rootModel.sections!.index(of: section) {
                rootModel.sections!.remove(at: index)
                outlineView.removeItems(at: IndexSet(integer: index), inParent: nil, withAnimation: NSTableView.AnimationOptions.slideLeft)
            }
            
        case let topic as Topic:
 
            if let section = parent as? Section {
                
                if (section.topics!.count == 1) {
                    print("Нельзя удалять единственный элемент!")
                    break
                }
                
                if let index = section.topics!.index(of: topic) {
                    section.topics!.remove(at: index)
                    outlineView.removeItems(at: IndexSet(integer: index), inParent: section, withAnimation: NSTableView.AnimationOptions.slideLeft)
                }
            }
            
        case let question as Question:
            
            if let test = parent as? Test {
                if let index = test.questions.index(of: question) {
                    test.questions.remove(at: index)
                    outlineView.removeItems(at: IndexSet(integer: index), inParent: test, withAnimation: NSTableView.AnimationOptions.slideLeft)
                }
            }
            
        case let checksVariant as QuestionChecksVariant:
            
            if let checks = parent as? QuestionChecks {
                if let index = checks.variants.index(of: checksVariant) {
                    checks.variants.remove(at: index)
                    outlineView.removeItems(at: IndexSet(integer: index), inParent: checks, withAnimation: NSTableView.AnimationOptions.slideLeft)
                }
            }
            
        case let gapsVariant as QuestionGapsVariant:
            
            if let gaps = outlineView.findParent(of: gapsVariant, type: QuestionGaps.self) {
                
                if (gaps.variants!.count == 1) {
                    print("Нельзя удалять единственный элемент!")
                    break
                }
                
                if let index = gaps.variants!.index(of: gapsVariant) {
                    gaps.variants!.remove(at: index)
                    outlineView.removeItems(at: IndexSet(integer: index), inParent: parent, withAnimation: NSTableView.AnimationOptions.slideLeft)
                }
            }
            
        case let gapsItem as QuestionGapsItem:
            
            if let gaps = outlineView.findParent(of: gapsItem, type: QuestionGaps.self) {
                
                if (gaps.items!.count == 1) {
                    print("Нельзя удалять единственный элемент!")
                    break
                }
                
                if let index = gaps.items!.index(of: gapsItem) {
                    gaps.items!.remove(at: index)
                    outlineView.removeItems(at: IndexSet(integer: index), inParent: parent, withAnimation: NSTableView.AnimationOptions.slideLeft)
                }
                outlineView.reloadItem(gaps, reloadChildren: true)
                outlineView.expandItem(gaps, expandChildren: true)
            }
  
        case let pairsItem as QuestionPairsItem:
            
            if let pairs = outlineView.findParent(of: pairsItem, type: QuestionPairs.self) {
                
                if (pairs.items!.count == 1) {
                    print("Нельзя удалять единственный элемент!")
                    break
                }
                
                if let index = pairs.items!.index(of: pairsItem) {
                    pairs.items!.remove(at: index)
                    outlineView.removeItems(at: IndexSet(integer: index), inParent: parent, withAnimation: NSTableView.AnimationOptions.slideLeft)
                    
                    outlineView.reloadItem(pairs, reloadChildren: true)
                    outlineView.expandItem(pairs, expandChildren: true)
                }
            }
    
        case let pairsVariant as QuestionPairsVariant:
            
            if let pairs = outlineView.findParent(of: pairsVariant, type: QuestionPairs.self) {
                
                if (pairs.variants!.count == 1) {
                    print("Нельзя удалять единственный элемент!")
                    break
                }
                
                if let index = pairs.variants!.index(of: pairsVariant) {
                    pairs.variants!.remove(at: index)
                    outlineView.removeItems(at: IndexSet(integer: index), inParent: pairs, withAnimation: NSTableView.AnimationOptions.slideLeft)
                    
                    outlineView.reloadItem(pairs, reloadChildren: true)
                    outlineView.expandItem(pairs, expandChildren: true)
                }
            }
            
        case let itemsElement as QuestionsStructureElement:
            
            if let questionsHtmlStructure = outlineView.findParent(of: itemsElement, type: QuestionsHtmlStructure.self) {
                if (questionsHtmlStructure.elements.count == 1) {
                    print("Нельзя удалять единственный элемент!")
                    break
                }
                
                if let index = questionsHtmlStructure.elements.index(of: itemsElement) {
                    questionsHtmlStructure.elements.remove(at: index)
                    outlineView.removeItems(at: IndexSet(integer: index), inParent: questionsHtmlStructure.elements, withAnimation: NSTableView.AnimationOptions.slideLeft)
                    
                    if let pairs = outlineView.findParent(of: itemsElement, type: QuestionPairs.self) {
                        outlineView.reloadItem(pairs, reloadChildren: true)
                        outlineView.expandItem(pairs, expandChildren: true)
                    }
                }
            }
            
        case let itemsElement as VariantsStructureElement:
            
            if let variantsHtmlStructure = outlineView.findParent(of: itemsElement, type: VariantsHtmlStructure.self) {
                if (variantsHtmlStructure.elements.count == 1) {
                    print("Нельзя удалять единственный элемент!")
                    break
                }
                
                if let index = variantsHtmlStructure.elements.index(of: itemsElement) {
                    variantsHtmlStructure.elements.remove(at: index)
                    outlineView.removeItems(at: IndexSet(integer: index), inParent: variantsHtmlStructure.elements, withAnimation: NSTableView.AnimationOptions.slideLeft)
                    
                    if let pairs = outlineView.findParent(of: itemsElement, type: QuestionPairs.self) {
                        outlineView.reloadItem(pairs, reloadChildren: true)
                        outlineView.expandItem(pairs, expandChildren: true)
                    }
                }
            }
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
        
        if let lessonQuickTest = parentTest as? LessonQuickTest {
            guard lessonQuickTest.questions.count == 0 else {
                print("В тесте по лекции не может быть более одного вопроса")
                return
            }
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
            outlineView.expandItem(test, expandChildren: true)
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
        
        if let lesson = item as? Lesson {
            let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditorLesson")) as! EditorLesson
            vc.lesson = lesson
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
        
        if let questionGapsVariant = item as? QuestionGapsVariant {
            let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditorQuestionGapsVariantVC")) as! EditorQuestionGapsVariantVC
            let valueTransformer = HTMLToAttributedString()
            
            vc.textView.bind(NSBindingName(rawValue: "attributedString"), to: questionGapsVariant, withKeyPath: "text", options: [.valueTransformer: valueTransformer])
            
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
        
        if let treeNodeExpandable = item as? TreeNodeExpandable {
            return treeNodeExpandable.numberOfChildren
        }
        
        //        if item == nil, let sections = self.rootModel.sections{
        //            return sections.count
        //        }

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
        
        if let treeNodeExpandable = item as? TreeNodeExpandable {
            return treeNodeExpandable.childAtIndex(index: index) ?? DateCell()
        }

        if let array = item as? Array<Any> {
            return array[index]
        }
        return DateCell() // stub
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        //        if let _ = item as? Question {
        //            return false
        //        }
        if let expandable = item as? Expandable {
            return expandable.isExpandable
        }
        return true
    }
}

extension ViewController: NSOutlineViewDelegate {
    
    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        let cell = (outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DateCell"), owner: self) as? DateCell)!
        
        if let textField = cell.textField {
            if let textFieldPresentable = item as? TextFieldPresentable {
                textFieldPresentable.setupTextField(textField: textField)
            }
            else {
                if let _ = item as? TextFieldPresentable {
                    
                }
                else if let _ = item as? [QuestionGapsVariant] {
                    textField.stringValue = "[Варианты ответов]"
                }
                else if let _ = item as? [QuestionGapsItem] {
                    textField.stringValue = "[Ответы]"
                }
                else if let _ = item as? [QuestionPairsItem] {
                    textField.stringValue = "[Вопросы]"
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
                else {
                    textField.stringValue = String(describing: item)
                }
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



