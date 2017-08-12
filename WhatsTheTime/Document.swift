//
//  Document.swift
//  WhatsTheTime
//
//  Created by Steven Adons on 12/08/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

import Foundation

let database: [String: (buttonTitle: String, urlString: String)] = [
    
    "PICTOGRAMU7U8" : (LS_DOCUMENTNAME_PICTOGRAMU7U8, "www.apple1.com"),
    "PICTOGRAMU9" : (LS_DOCUMENTNAME_PICTOGRAMU9, "www.apple1.com"),
    "PICTOGRAMU10U12" : (LS_DOCUMENTNAME_PICTOGRAMU10U12, "www.apple1.com"),
    "VHLSHOOTOUTS" : (LS_DOCUMENTNAME_VHLSHOOTOUTS, "www.apple1.com"),
    "VHLRULESU7U12" : (LS_DOCUMENTNAME_VHLRULESU7U12, "www.apple1.com"),
    "VHLRULESU14U19" : (LS_DOCUMENTNAME_VHLRULESU14U19, "www.apple1.com"),
    "KBHBRULES" : (LS_DOCUMENTNAME_KBHBRULES, "www.apple1.com")

]

struct Document {
    
    
    // MARK: - Properties
    
    var name: String!
    var buttonTitle: String!
    var url: String!
    
    
    // MARK: - Initializing
    
    init(name: String) {
        
        self.name = name
        self.buttonTitle = database[name]?.buttonTitle ?? "NO TITLE"
        self.url = database[name]?.urlString ?? "NO URL"
    }
    
    
    // MARK: - Static func
    
    static func allDocuments() -> [Document] {
        
        var documents: [Document] = []
        for key in database.keys {
            documents.append(Document(name: key))
        }
        return documents
    }

    
    
}
