//
//  ViewController.swift
//  Midterm - NYC Login
//
//  Created by Sophia Richter on 3/8/16.
//  Copyright © 2016 Sophia Richter. All rights reserved.
//

import UIKit
import Firebase
import Google

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    let ref = Firebase(url:"https://mynyc.firebaseio.com")
    
    var auth: FAuthData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }

    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var currentLoggedInUser: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func authenticateWithGoogle(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
        // Implement the required GIDSignInDelegate methods
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
        withError error: NSError!) {
            if (error == nil) {
                // Auth with Firebase
                ref.authWithOAuthProvider("google", token: user.authentication.accessToken, withCompletionBlock: { (error, authData) in
                    self.auth = authData
                   // self.currentLoggedInUser.text = authData.providerData["displayName"] as? String
                    let uid = authData!.uid
                    
                    let ref = Firebase(url:"https://mynyc.firebaseio.com/users/\(uid)")
                    ref.observeEventType(.Value, withBlock: {
                        snapshot in
                        self.currentValueLabel.text = "\(snapshot.value)"
                    })
                    
                    
                })
            } else {
                // Don't assert this error it is commonly returned as nil
                print("\(error.localizedDescription)")
            }
    }
//    @IBAction func saveToFirebase() {
//        let uid = auth!.uid
//        
//        let ref = Firebase(url:"https://mynyc.firebaseio.com/users/\(uid)")
//        
//        ref.setValue(nameTextField.text)
//    }
   
    
    

   

    
//        @IBAction func signOut() {
//            GIDSignIn.sharedInstance().signOut()
//            ref.unauth()
//            self.currentLoggedInUser.text = "Logged out"
//        }
    
    

    // Implement the required GIDSignInDelegate methods
    // Unauth when disconnected from Google
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
        withError error: NSError!) {
            ref.unauth();
            self.currentLoggedInUser.text = "Logged out"
    }


}

