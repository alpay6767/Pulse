//
//  Session.swift
//  Pulse
//
//  Created by Alpay Kücük on 13.03.24.
//

import Foundation
import FirebaseDatabase

class Session {
    
    var id: String?
    var userid: String?
    var time: Date?
    var placeid: String?
    var currentUser: User?
            
    init(id: String?, userid: String? = nil, placeid: String? = nil) {
        self.id = id
        self.userid = userid
        self.placeid = placeid
    }
    
    init?(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String : AnyObject]
        self.id = value!["id"] as? String
        self.userid = value!["userid"] as? String
        self.placeid = value!["placeid"] as? String
    }
    
    init() {
    }
    
    init?(snapshotsingle: DataSnapshot) {
        let value = snapshotsingle.value as? [String : AnyObject]
        self.id = value!["id"] as? String
    }
    
    
}
