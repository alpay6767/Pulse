//
//  Place.swift
//  Pulse
//
//  Created by Metin Atac on 03.03.24.
//

import Foundation
class Place {
    var id: String
    var sessionID: String
    var placeName: String
    
    init(id: String, sessionID: String, placeName: String) {
        self.id = id
        self.sessionID = sessionID
        self.placeName = placeName
    }
}
