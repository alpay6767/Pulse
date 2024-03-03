//
//  Chat.swift
//  Pulse
//
//  Created by Metin Atac on 03.03.24.
//

import Foundation
class Chat {
    var id: String
    var sessionIDs : [String]
    var messageIDs: [String]
    
    
    init(id: String, sessionIDs: [String], messageIDs: [String]) {
        self.id = id
        self.sessionIDs = sessionIDs
        self.messageIDs = messageIDs
    }
}
