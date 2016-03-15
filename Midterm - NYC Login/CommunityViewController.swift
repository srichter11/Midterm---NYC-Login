//
//  CommunityViewController.swift
//  Midterm - NYC Login
//
//  Created by Sophia Richter on 3/14/16.
//  Copyright © 2016 Sophia Richter. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(image: UIImage(named: "water.jpeg"))
        imageView.frame = view.bounds
        imageView.contentMode = .ScaleToFill
        view.addSubview(imageView)
        
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = imageView.bounds
        view.addSubview(blurredEffectView)
        
        view.sendSubviewToBack(blurredEffectView)
        view.sendSubviewToBack(imageView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
