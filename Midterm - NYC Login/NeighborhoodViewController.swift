//
//  NeighborhoodViewController.swift
//  Midterm - NYC Login
//
//  Created by Sophia Richter on 3/14/16.
//  Copyright © 2016 Sophia Richter. All rights reserved.
//

import UIKit

class NeighborhoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 1 {
            return
                tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
        }
        
        if indexPath.row == 2 {
            return
                tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath)
        }
        
        if indexPath.row == 3 {
            return
                tableView.dequeueReusableCellWithIdentifier("cell3", forIndexPath: indexPath)
        }
        if indexPath.row == 4 {
            return
                tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        

        return cell
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

