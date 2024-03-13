//
//  Place.swift
//  Pulse
//
//  Created by Alpay Kücük on 13.03.24.
//

import Foundation
import FirebaseDatabase

class Place {
    
    var id: String?
    var name: String?
    var users = [User]()
            
    init(id: String?, name: String? = nil) {
        self.id = id
        self.name = name
    }
    
    init?(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String : AnyObject]
        self.id = value!["id"] as? String
        self.name = value!["name"] as? String
    }
    
    init() {
    }
    
    init?(snapshotsingle: DataSnapshot) {
        let value = snapshotsingle.value as? [String : AnyObject]
        self.id = value!["id"] as? String
    }
}
