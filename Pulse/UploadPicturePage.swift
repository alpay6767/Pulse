//
//  UploadPicturePage.swift
//  BeSleek
//
//  Created by Alpay Kücük on 20.02.23.
//

import Foundation
import UIKit
import FirebaseStorage
import FMPhotoPicker
import FirebaseDatabase
import FirebaseAuth
import JGProgressHUD

class UploadPicturePage: UIViewController, FMPhotoPickerViewControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    var selectedImage: UIImage?
    let firebaseHandler = FBHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        hideKeyboardWhenTappedAround()
        image.layer.cornerRadius = image.bounds.width/2
        image.clipsToBounds = true
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func `continue`(_ sender: Any) {
        register()
    }
    
    @IBAction func changePhotoPressed(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
        
        var config = FMPhotoPickerConfig()
        config.maxImage = 1
        config.mediaTypes = [.image]
        config.selectMode = .single
        config.availableCrops = [FMCrop.ratioSquare,
                                 FMCrop.ratio4x3,
                                 FMCrop.ratio16x9]
        
        let picker = FMPhotoPickerViewController(config: config)
        picker.delegate = self
        self.present(picker, animated: true)
        // Your action
    }
    
    func register() {
        if (self.selectedImage == nil) {
            self.showBanner(title: "Something went wrong!", subtitle: "You haven't selected a picture", style: .warning)
        } else {
            if(AppDelegate.currentUser != nil) {
                saveInDatabase()
            }
        }
        
    }
    
    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        self.selectedImage = photos[0]
        image.image = selectedImage
        picker.dismiss(animated: true) {
            
        }
    }
    
    
    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        self.selectedImage = photo
        image.image = selectedImage
    }
    
    func uploadMedia(completion: @escaping (_ url: String?, _ key: String?) -> Void) {

        var ref: DatabaseReference!
        ref = Database.database(url: "https://pulse-34f7d-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        let id = AppDelegate.currentUser.id!

        let storageRef = Storage.storage().reference().child("Users").child(id).child(id + ".png")
        if let uploadData = selectedImage!.jpegData(compressionQuality: 0.1) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.showBanner(title: "Something went wrong!", subtitle: "Try it again!", style: .warning)
                    print("error" + error.debugDescription)
                    completion(nil, id)
                } else {

                    storageRef.downloadURL(completion: { (url, error) in
                        print(url?.absoluteString)
                        completion(url?.absoluteString, id)
                    })

                  //  completion((metadata?.downloadURL()?.absoluteString)!))
                    // your uploaded photo url.


                }
            }
        }
    }
    
    func saveInDatabase() {
        
        // - start loading screen:
        let hud = JGProgressHUD()
        //hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.textLabel.text = "Saving"
        hud.show(in: self.view)

        var ref: DatabaseReference!
        ref = Database.database(url: "https://pulse-34f7d-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        let key = ref.child("Places").child(AppDelegate.currentPlace.id!).child("Sessions").childByAutoId().key
        AppDelegate.currentUser.id = key
        
        self.uploadMedia(){ url, key in
        guard let url = url else {
            hud.dismiss(animated: true)
            return
        }
        guard let id = key else {
            hud.dismiss(animated: true)
            return
        }
            
            AppDelegate.currentUser.profilePictureUrl = url
            AppDelegate.currentUser.placeid = AppDelegate.currentPlace.id
            self.firebaseHandler.createSessionInDatabase(currentUser: AppDelegate.currentUser, place: AppDelegate.currentPlace)
            hud.dismiss(animated: true)
            
            /*let newView = self.storyboard?.instantiateViewController(withIdentifier: "homepage") as! HomePage
            self.navigationController?.pushViewController(newView, animated: true)
            
            if let navigationController = self.navigationController {
                var updatedViewControllers = navigationController.viewControllers
                updatedViewControllers.remove(at: 0) // Remove the first view controller (login view controller)
                navigationController.viewControllers = updatedViewControllers
            }
             */
        }
    }
}
