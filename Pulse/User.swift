//
//  User.swift
//  Pulse
//
//  Created by Alpay Kücük on 13.03.24.
//
import Foundation
import UIKit
import FirebaseDatabase

class User {
    
    var id: String?
    var name: String?
    var flames: Int?
    var profilePictureUrl: String?
    var placeid: String?
    var profilePicture : UIImage? = UIImage(named: "default_profile")!
    var blockedList = [String]()
    var likedList = [String]()
            
    init(id: String?, name: String? = nil, flames: Int? = nil, profilePictureUrl: String? = nil, placeid: String? = nil,profilePicture: UIImage? = nil) {
        self.id = id
        self.name = name
        self.flames = flames
        self.placeid = placeid
        self.profilePictureUrl = profilePictureUrl
    }
    
    init?(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String : AnyObject]
        self.id = value!["id"] as? String
        self.name = value!["name"] as? String
        self.flames = value!["flames"] as? Int
        self.profilePictureUrl = value!["profilepictureurl"] as? String
        self.placeid = value!["placeid"] as? String
    }
    
    init() {
    }
    
    init?(snapshotsingle: DataSnapshot) {
        let value = snapshotsingle.value as? [String : AnyObject]
        self.id = value!["id"] as? String
    }
    
    func loadBlockedUser() {
        let defaults = UserDefaults.standard
        blockedList = defaults.object(forKey:(id! + "blockarray")) as? [String] ?? [String]()
    }
    
    func RemoveAllBlockedContent() {
        let defaults = UserDefaults.standard
        defaults.set([String](), forKey: (id! + "blockarray"))
        blockedList = []
    }
    
    func loadLickedPosts() {
        let defaults = UserDefaults.standard
        likedList = defaults.object(forKey:(id! + "likedarray")) as? [String] ?? [String]()
    }
    
    func hasBlockedUser(playerid: String) -> Bool {
        
        for userid in blockedList {
            if userid == playerid {
                return true
            }
        }
        return false
    }
    
    func hasBlockedContent(contentid: String) -> Bool {
        
        for id in blockedList {
            if contentid == id {
                return true
            }
        }
        return false
    }
    
    func hasLikedPost(postid: String) -> Bool {
        
        for currentpostid in likedList {
            if currentpostid == postid {
                return true
            }
        }
        return false
    }
    
    func blockUser(playerid: String) {
        blockedList.append(playerid)
        let defaults = UserDefaults.standard
        defaults.set(blockedList, forKey: (id! + "blockarray"))
    }
    
    func blockContent(contentid: String) {
        blockedList.append(contentid)
        let defaults = UserDefaults.standard
        defaults.set(blockedList, forKey: (id! + "blockarray"))
    }
    
    func likeId(postid: String) {
        likedList.append(postid)
        let defaults = UserDefaults.standard
        defaults.set(likedList, forKey: (id! + "likedarray"))
    }
    
    func unblockUser(playerid: String) {
        var counter = 0
        for userid in blockedList {
            if userid == playerid {
                blockedList.remove(at: counter)
                break
            }
            counter+=1
        }
        let defaults = UserDefaults.standard
        defaults.set(blockedList, forKey: (id! + "blockarray"))
    }
    
    func dislikeId(postid: String) {
        var counter = 0
        for currentpostid in likedList {
            if currentpostid == postid {
                likedList.remove(at: counter)
                break
            }
            counter+=1
        }
        let defaults = UserDefaults.standard
        defaults.set(likedList, forKey: (id! + "likedarray"))
    }
    
}
