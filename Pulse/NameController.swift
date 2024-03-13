//
//  NameController.swift
//  Pulse
//
//  Created by Alpay Kücük on 13.03.24.
//

import Foundation
import UIKit
import NotificationBannerSwift

class NameController: UIViewController {
    
    @IBOutlet weak var namefield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func `continue`(_ sender: Any) {
        if(namefield.text == "") {
            showBanner(title: "Please give a name", subtitle: "name is missing", style: .warning)
        } else {
            AppDelegate.currentUser.name = namefield.text
            let newView = self.storyboard?.instantiateViewController(withIdentifier: "uploadpicturepage") as! UploadPicturePage
            self.navigationController?.pushViewController(newView, animated: true)
            
        }
    }
}
