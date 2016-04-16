//
//  ZipcodeInfo.swift
//  Midterm - NYC Login
//
//  Created by Sophia Richter on 4/14/16.
//  Copyright © 2016 Sophia Richter. All rights reserved.
//
import Foundation

class ZipcodeInfo: NSObject {
    
    static var zipCode: String?
    
    static func getZipCode() -> String? {
        
        NSUserDefaults.standardUserDefaults().synchronize()

        if let myZipCode = zipCode {
            return myZipCode
        }else {
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let zip = defaults.stringForKey("zip_string")
            
            zipCode = zip
            
            return zip

        }
        
    }
    
    static func saveZipCode(zip: String) {
        zipCode = zip
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("\(zip)", forKey: "zip_string")
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
}
