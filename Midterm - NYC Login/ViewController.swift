//
//  ViewController.swift
//  Midterm - NYC Login
//
//  Created by Sophia Richter on 3/8/16.
//  Copyright © 2016 Sophia Richter. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

@IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let zipCode = ZipcodeInfo.getZipCode() {
            nameTextField.text = zipCode
        }
    }

    
    func saveZip () {
        if let zipcode = nameTextField.text {
        ZipcodeInfo.saveZipCode(zipcode)
        NSUserDefaults.standardUserDefaults().synchronize()

        }
    }
    
    func displayAlert (alertString: String) {
        let alert = UIAlertController(title: "Invalid", message: alertString, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "move" {
            if let destinationVC = segue.destinationViewController as? UINavigationController {
                
                if let input = nameTextField.text {
                   if nameTextField.text!.characters.count != 5 {
                    displayAlert("Please enter a valid zipcode")
                }
                   else {
                    saveZip()

                    }
                }
            }
        }
}
}
