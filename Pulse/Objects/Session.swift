//
//  Session.swift
//  Pulse
//
//  Created by Metin Atac on 03.03.24.
//
import Foundation
class Session {
    var id: String
    var userName: String
    var chatsID: String
    var photoURL: String
    var chatIDs: [String]
    
    init(id: String, userName: String, chatsID: String, photoURL:String) {
        self.id = id
        self.userName = userName
        self.chatsID = chatsID
        self.photoURL = photoURL
    }
}
