//
//  MeetupDetailViewController.swift
//  Midterm - NYC Login
//
//  Created by Sophia Richter on 4/13/16.
//  Copyright © 2016 Sophia Richter. All rights reserved.
//

import UIKit

class MeetupDetailViewController: UIViewController {
    @IBAction func closeButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
  
    
   @IBOutlet weak var webView: UIWebView!
    
    var storyToLoad : NSURLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storyToLoad = storyToLoad {
            webView.loadRequest(storyToLoad)
        }
        // Do any additional setup after loading the view.
    }
}