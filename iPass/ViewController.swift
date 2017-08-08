//
//  ViewController.swift
//  iPass
//
//  Created by Yuto Kobayashi on 8/8/17.
//  Copyright © 2017 Yuto Kobayashi. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func authenticateUser() {
        // Get the local authentication context.
        let context = LAContext()
        
        // Declare a NSError variable.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        var reasonString = "Authentication is needed to access your notes."
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error:nil) {
            
            // 2.
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: "Logging in with Touch ID",
                                   reply: { (success : Bool, error : NSError? ) -> Void in
                                    
                                    // 3.
                                    DispatchQueue.main.async(execute: {
                                        if success {
                                            self.performSegue(withIdentifier: "dismissLogin", sender: self)
                                        }
                                        
                                        if error != nil {
                                            
                                            var message : NSString
                                            var showAlert : Bool
                                            
                                            // 4.
                                            switch(error!.code) {
                                            case LAError.authenticationFailed.rawValue:
                                                message = "There was a problem verifying your identity."
                                                showAlert = true
                                                break;
                                            case LAError.userCancel.rawValue:
                                                message = "You pressed cancel."
                                                showAlert = true
                                                break;
                                            case LAError.userFallback.rawValue:
                                                message = "You pressed password."
                                                showAlert = true
                                                break;
                                            default:
                                                showAlert = true
                                                message = "Touch ID may not be configured"
                                                break;
                                            }
                                            
                                            let alertView = UIAlertController(title: "Error",
                                                                              message: message as String, preferredStyle:.alert)
                                            let okAction = UIAlertAction(title: "Darn!", style: .default, handler: nil)
                                            alertView.addAction(okAction)
                                            if showAlert {
                                                self.present(alertView, animated: true, completion: nil)
                                            }
                                            
                                        }
                                    })
                                    
            } as! (Bool, Error?) -> Void)
        } else {
            // 5.
            let alertView = UIAlertController(title: "Error",
                                              message: "Touch ID not available" as String, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Darn!", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
            
        }
    }
    
    func showPasswordAlert() {
        let passwordAlert : UIAlertView = UIAlertView(title: "TouchIDDemo", message: "Please type your password", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Okay")
        passwordAlert.alertViewStyle = UIAlertViewStyle.secureTextInput
        passwordAlert.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            if !(alertView.textField(at:0)!.text?.isEmpty)! {
                if alertView.textField(at: 0)!.text == "appcoda" {
                    
                }
                else{
                    showPasswordAlert()
                }
            }
            else{
                showPasswordAlert()
            }
        }
    }

}

