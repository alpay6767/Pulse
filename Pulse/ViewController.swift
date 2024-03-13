//
//  ViewController.swift
//  Pulse
//
//  Created by Alpay Kücük on 02.03.24.
//

import UIKit
import CoreNFC
import AVFoundation
import NotificationBannerSwift

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    
    @IBOutlet weak var scanIcon: UIImageView!
    var session: NFCNDEFReaderSession?
    
    let firebaseHandler = FBHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initView()
        startNFCScan()
        
    }
    
    func initView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scanButtonTapped(tapGestureRecognizer:)))
        scanIcon.isUserInteractionEnabled = true
        scanIcon.addGestureRecognizer(tapGestureRecognizer)
    }
    @IBAction func showAdminPage(_ sender: Any) {
        let newView = self.storyboard?.instantiateViewController(withIdentifier: "adminpage") as! AdminPage
        self.navigationController?.pushViewController(newView, animated: true)
    }
    
    @IBAction func startScan(_ sender: Any) {
        let tapticFeedback = UINotificationFeedbackGenerator()
        tapticFeedback.notificationOccurred(.success)
        // Your action
        startNFCScan()
    }
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                if let string = String(data: record.payload, encoding: .ascii) {
                    print(string)
                    let recognizedPlace = string.dropFirst(3)
                    print(recognizedPlace)
                    //load Place with scanned id:
                    firebaseHandler.loadPlace(palceId: String(recognizedPlace)) { foundPlace in
                        guard let foundPlace = foundPlace else {
                            self.showBanner(title: "Sticket not recognized!", subtitle: "please scan a pulse sticket!", style: .danger)
                            return
                        }
                        self.session = nil
                        AppDelegate.currentPlace = foundPlace
                        let newView = self.storyboard?.instantiateViewController(withIdentifier: "namepage") as! NameController
                        self.navigationController?.pushViewController(newView, animated: true)
                    }
                }
            }
        }
    }
    
    func startNFCScan() {
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone near the pulse sticker."
        session?.begin()
    }
    
    @objc func scanButtonTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let tapticFeedback = UINotificationFeedbackGenerator()
        tapticFeedback.notificationOccurred(.success)
        // Your action
        startNFCScan()
    }
    
    

}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showBanner(title: String, subtitle: String, style: BannerStyle) {
        let banner = FloatingNotificationBanner(
            title: title,
            subtitle: subtitle,
            style: style
        )
        banner.haptic = .heavy
        banner.show(
            bannerPosition: .top,
            cornerRadius: 8,
            shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        )
    }
}
