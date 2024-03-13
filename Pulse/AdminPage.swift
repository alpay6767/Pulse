//
//  AdminPage.swift
//  Pulse
//
//  Created by Alpay Kücük on 13.03.24.
//

import Foundation
import UIKit

class AdminPage: UIViewController {
    
    @IBOutlet weak var namefield: UITextField!
    let firebaseHandler = FBHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
    }
    
    @IBAction func createPlace(_ sender: Any) {
        if(namefield.text == "") {
            showBanner(title: "Please give a name", subtitle: "name is missing", style: .warning)
        } else {
            let newPlace = Place(id: "", name: namefield.text)
            firebaseHandler.createPlaceInDatabase(place: newPlace)
        }
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
