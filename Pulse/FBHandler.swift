//
//  FBHandler.swift
//  Kontaki
//
//  Created by Alpay Kücük on 15.05.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth


class FBHandler {
    
    var nothandler: DatabaseHandle!
    var singlechatmessageshandler: DatabaseHandle!
    var groupchatmessageshandler: DatabaseHandle!
    var postcommentshandler: DatabaseHandle!

    init() {
        
    }
    
    static func getUserFromDefaults() -> User {
        
        let defaults = UserDefaults.standard
        let id = defaults.string(forKey: "id")
        let name = defaults.string(forKey: "name")
        let profilepictureurl = defaults.string(forKey: "profilepictureurl")
        let flames = defaults.integer(forKey: "flames")
        let placeid = defaults.string(forKey: "placeid")
        let foundUser = User(id: id!, name: name!, flames: flames, profilePictureUrl: profilepictureurl!, placeid: placeid)
        return foundUser
        
    }
    
    static func logoutUser() {
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    func createSessionInDatabase(currentUser: User, place: Place) {
        var ref: DatabaseReference!
        ref = Database.database(url: "https://pulse-34f7d-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        ref.child("Places").child(place.id!).child("Sessions").child(currentUser.id!).setValue(["id": currentUser.id, "name": currentUser.name, "flames": 0,"profilepictureurl": currentUser.profilePictureUrl, "placeid": place.id!])
        
        FBHandler.saveUserToDefaults(user: currentUser)
    }
    
    func createPlaceInDatabase(place: Place) {
        var ref: DatabaseReference!
        ref = Database.database(url: "https://pulse-34f7d-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        let key = ref.child("Places").childByAutoId().key
        place.id = key
        
        ref.child("Places").child(place.id!).setValue(["id": place.id, "name": place.name])
    }
    
    
    func getDataFromUrl(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, imageview: UIImageView) {
        print("Download Started")
        getDataFromUrl(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                imageview.image = UIImage(data: data)
            }
        }
    }
    
    func loadUserWithIdInPlace(userid: String, place: Place, completion: @escaping (_ foundFreund: User?) -> Void){
        
        var ref: DatabaseReference!
        ref = Database.database(url: "https://pulse-34f7d-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        ref?.child("Places").child(place.id!).child("Sessions").child(userid).observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            let foundUser = User(snapshot: snapshot)
            completion(foundUser)
            
        })
    }
    
    func loadPlace(palceId: String, completion: @escaping (_ foundPlace: Place?) -> Void){
        
        var ref: DatabaseReference!
        ref = Database.database(url: "https://pulse-34f7d-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        ref?.child("Places").child(palceId).observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            let foundPlace = Place(snapshot: snapshot)
            completion(foundPlace)
            
        })
    }
    
    func loadUsersOfPlace(place: Place, completion: @escaping (_ users: [User]?) -> Void){
        
        //ladePostsVonFreunden für Flapsscreen!
        var ref: DatabaseReference!
        ref = Database.database(url: "https://pulse-34f7d-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        var usersOfPlace = [User]()
                
        ref?.child("Places").child(place.id!).child("Sessions").observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                completion([User]())
                return
            }
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                usersOfPlace = [User]()
                for child in result {
                    let loadedUser = User(snapshot: child)
                    usersOfPlace.append(loadedUser!)
                }
                completion(usersOfPlace)
            }
        })
    }
    
    func ausloggen() {
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
      
    }
        
    static func saveUserToDefaults(user: User) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "LoggedIn")
        defaults.set(user.id, forKey: "id")
        defaults.set(user.name, forKey: "name")
        defaults.set(user.placeid, forKey: "placeid")
        defaults.set(user.profilePictureUrl, forKey: "profilepictureurl")
        defaults.set(user.flames, forKey: "flames")
    }
    
}


extension UIImageView {
    func downloaded(from url: URL, mode: UIView.ContentMode) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, mode: UIView.ContentMode) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, mode: mode)
    }
}

extension String {

    func removingAllWhitespaces() -> String {
        return removingCharacters(from: .whitespaces)
    }

    func removingCharacters(from set: CharacterSet) -> String {
        var newString = self
        newString.removeAll { char -> Bool in
            guard let scalar = char.unicodeScalars.first else { return false }
            return set.contains(scalar)
        }
        return newString
    }
}
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
