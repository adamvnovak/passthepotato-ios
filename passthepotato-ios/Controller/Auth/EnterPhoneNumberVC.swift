//
//  ViewController.swift
//  passthepotato-ios
//
//  Created by Adam Novak on 2022/11/08.
//

import UIKit
import FirebaseAuth

class EnterPhoneNumberViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func verifyPhoneNumber() {
        
//        PhoneAuthProvider.provider()
//          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
//              if let error = error {
//                self.showMessagePrompt(error.localizedDescription)
//                return
//              }
//              //text was successfully sent.
//              //save verificationID in AuthContext,
//              //push view controller
//              
//          }
        
        //make sure the
        
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    }

}

