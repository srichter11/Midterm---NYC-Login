//
//  CommunityViewController.swift
//  Midterm - NYC Login
//
//  Created by Sophia Richter on 3/14/16.
//  Copyright © 2016 Sophia Richter. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class CommunityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

@IBOutlet weak var tableView: UITableView!
   
override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData("Civic%20Services")
    }

var serviceJSON : [JSON] = []
var serviceInfo : [JSON] = []


    func getData (serviceCategory: String) {

        Alamofire.request(.GET, "https://api.cityofnewyork.us/311/v1/services/\(serviceCategory).json?app_id=09fd47fe&app_key=4604c3969c456fe434e54071045498b5").responseData { response in
            if let data = response.data {
                let json = JSON(data: data)
                print(json[].arrayValue)
                self.serviceInfo = json[].arrayValue
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()})
            }
        }
    }

    
@IBAction func favoritesClicked(sender: UISegmentedControl) {
            switch sender.selectedSegmentIndex {
            case 0:getData("Civic%20Services")
            case 1:getData("Culture%20and%20Recreation")
            case 2:getData("Education")
            case 3:getData("Public%20Safety")
            case 4:getData("Social%20Services")
               // sender.selectedSegmentIndex = -1
            default: break
        }
    }
    
func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
    return serviceInfo.count
}

func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    
    let majorLabel = cell.viewWithTag(100) as! UILabel
    majorLabel.text = serviceInfo[indexPath.row]["service_name"].stringValue
    
    let subLabel = cell.viewWithTag(550) as! UILabel
    subLabel.text = serviceInfo[indexPath.row]["brief_description"].stringValue
    
    return cell
}


func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let selectedItem = serviceInfo[indexPath.row]
    let serviceID = selectedItem["id"].stringValue
    
    
    Alamofire.request(.GET, "https://api.cityofnewyork.us/311/v1/services/\(serviceID).json?app_id=09fd47fe&app_key=4604c3969c456fe434e54071045498b5").responseData { response in
        if let data = response.data {
            let json = JSON(data: data)
            print(json[].arrayValue)
            
            
            let webURLString = json[0]["url"].stringValue
            let fullWebString = "http://www1.nyc.gov/\(webURLString)"
            let webURL = NSURL(string: fullWebString)
            let webURLRequest = NSURLRequest(URL: webURL!)
            self.performSegueWithIdentifier("web", sender: webURLRequest)
        }
    }
}

override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "web" {
        let faqDetailVC = segue.destinationViewController as? FAQDetailViewController
        faqDetailVC?.storyToLoad = sender as? NSURLRequest
        }
    }
}


