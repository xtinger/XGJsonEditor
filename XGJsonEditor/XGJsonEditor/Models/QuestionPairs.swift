//
//  QuestionPairs.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

class QuestionPairs: Question {
    // html содержимое или обычный текст (Установите соответствие...)
    var text: String?
    // html содержимое списка
    var itemsHtml: String?
    // список описаний вопросов
    var items: [QuestionPairsItem]?
    // html содержимое списка с вариантами ответов
    var variantsHtml: String?
    // список описаний вариантов ответа
    var variants: [QuestionPairsVariant]?
}
