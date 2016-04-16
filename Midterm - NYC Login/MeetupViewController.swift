//
//  MeetupViewController.swift
//  Midterm - NYC Login
//
//  Created by Sophia Richter on 4/13/16.
//  Copyright © 2016 Sophia Richter. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MeetupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let zip: String = ZipcodeInfo.getZipCode()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "getData", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
        getData(zip)
        
        // unrecognized selector is the refresh control 
        
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
    
    var serviceInfo : [JSON] = []
    let placeholderImage = UIImage(named: "User Groups-50.png")
    var refreshControl : UIRefreshControl?

    

    
    func getData (zipcode: String) {
        
        Alamofire.request(.GET, "https://api.meetup.com/2/groups?&sign=true&photo-host=public&zip=\(zipcode)&radius=0.5&page=100&key=22a6c4c52416d61413c41b34784119").responseData { response in
            if let data = response.data {
                let json = JSON(data: data)
                //print(json["results"].arrayValue)
                self.serviceInfo = json["results"].arrayValue
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()})
            }
        }
    
    }

    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("meetupCell", forIndexPath: indexPath)
        
        let majorLabel = cell.viewWithTag(10) as! UILabel
        majorLabel.text = serviceInfo[indexPath.row]["name"].stringValue
        
        let subLabel = cell.viewWithTag(1) as! UILabel
        subLabel.text = serviceInfo[indexPath.row]["who"].stringValue
        
        let imageURL = serviceInfo[indexPath.row]["group_photo"]["photo_link"].stringValue
        
        cell.imageView?.image = nil
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: placeholderImage!.size, radius: 5.0)
        
        let URL = NSURL(string: imageURL)
        cell.imageView?.af_setImageWithURL(URL!, placeholderImage: placeholderImage, filter: filter, imageTransition: .CrossDissolve(0.9), runImageTransitionIfCached: false, completion: { (response) in
            cell.setNeedsLayout()} )
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                let selectedItem = serviceInfo[indexPath.row]
                let webURLString = selectedItem["link"].stringValue
                print(webURLString)
                let webURL = NSURL(string: webURLString)
                let webURLRequest = NSURLRequest(URL: webURL!)
                performSegueWithIdentifier("detailView", sender: webURLRequest)
            }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailView" {
            let meetupDetailVC = segue.destinationViewController as? MeetupDetailViewController
            meetupDetailVC?.storyToLoad = sender as? NSURLRequest
        }
    }

}



