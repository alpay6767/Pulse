//
//  Message.swift
//  Pulse
//
//  Created by Metin Atac on 03.03.24.
//

import Foundation
class Message {
    var id: String
    var messageValue : String
    var timeSend: String
    
    
    init(id: String, messageValue: String, timeSend: String) {
        self.id = id
        self.messageValue = messageValue
        self.timeSend = timeSend
    }
}
