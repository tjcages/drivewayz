//
//  FAQs.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 8/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class FAQs: NSObject {
    
    var mainInformation: [String]?
    var supportText: String?
    var contactSupport: String?
    
    var helpful: Bool?
    var like: Int?
    var dislike: Int?
    
    init(dictionary: [String: Any]) {
        super.init()
        
        mainInformation = dictionary["mainInformation"] as? [String]
        supportText = dictionary["supportText"] as? String
        contactSupport = dictionary["contactSupport"] as? String
        
        helpful = dictionary["helpful"] as? Bool
        like = dictionary["like"] as? Int
        dislike = dictionary["dislike"] as? Int
        
    }
    
}

struct QuestionsStruct {
    let title: String
    let key: String
}

struct QuestionTopicsStruct {
    let page: String?
    let title: String
    let notes: String?
    let questions: [QuestionsStruct]?
}

struct QuickTopicsStruct {
    let page: String
    let title: String
    let subtitle: String
}

class FrequentlyAskedQuestions: NSObject {
    
    var QuestionTopics: [String: Any]?
    var QuickTopics: [String: Any]?
    var Answers: [String: Any]?
    
    var questionTopics: [QuestionTopicsStruct]?
    var quickTopics: [QuickTopicsStruct]?
    
    init(dictionary: [String: Any]) {
        super.init()
        
        QuestionTopics = dictionary["QuestionTopics"] as? [String: Any]
        QuickTopics = dictionary["QuickTopics"] as? [String: Any]
        Answers = dictionary["Answers"] as? [String: Any]
        
        if let questions = QuestionTopics {
            questionTopics = []
            for question in questions {
                if let values = question.value as? [String: Any] {
                    let title = question.key
                    if let page = values["page"] as? String {
                        let notes = values["notes"] as? String
                        let topic = QuestionTopicsStruct(page: page, title: title, notes: notes, questions: nil)
                        questionTopics?.append(topic)
                    } else {
                        var valueKeys: [QuestionsStruct] = []
                        for value in values {
                            let key = value.key
                            if let title = value.value as? String {
                                let question = QuestionsStruct(title: title, key: key)
                                valueKeys.append(question)
                            }
                        }
                        let topic = QuestionTopicsStruct(page: nil, title: title, notes: nil, questions: valueKeys)
                        questionTopics?.append(topic)
                    }
                }
            }
        }
        
        if let quick = QuickTopics {
            quickTopics = []
            for quicky in quick {
                if let values = quicky.value as? [String: Any], let page = values["page"] as? String, let subtitle = values["subtitle"] as? String {
                    let topic = QuickTopicsStruct(page: page, title: quicky.key, subtitle: subtitle)
                    quickTopics?.append(topic)
                }
            }
        }
        
    }
    
}


