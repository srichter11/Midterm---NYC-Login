//
//  AccountViewController.swift
//  Midterm - NYC Login
//
//  Created by Sophia Richter on 3/8/16.
//  Copyright © 2016 Sophia Richter. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func displayAlert (alertString: String) {
        let alert = UIAlertController(title: "Invalid", message: alertString, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    }
    
    
    @IBAction func signUpButton(sender: AnyObject) {
 
        let name = self.nameTextField.text
        let zipcode = self.zipcodeTextField.text
        let birthday = self.birthdayTextField.text
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        if name?.characters.count < 2 {
           displayAlert("Name is missing")
            
        } else if password?.characters.count < 8 {
            displayAlert("Password must be at least 8 characters")
            
        } else if email?.characters.count < 8 {
            displayAlert("Please enter a valid email address")

        } else if zipcode?.characters.count != 5 {
            displayAlert("Please enter a valid zipcode")
            // how do i ensure this is an integer? perhaps test if can convert to int.

        } else if birthday?.characters.count != 8 {
            displayAlert("Please enter a valid  birthday in the format 00/00/00")
            
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    
    }
    @IBAction func closeButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
