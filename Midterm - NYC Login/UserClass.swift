//
//  NYCTextField.swift
//  Midterm - NYC Login
//
//  Created by Sophia Richter on 3/8/16.
//  Copyright © 2016 Sophia Richter. All rights reserved.
//

import UIKit

class User {
    
    var name: String
    var zipcode: String
    var birthday: String
    var email: String
    var password: String
    
    init (name: String, zipcode: String, birthday: String, email: String, password: String) {
        self.name = name
        self.zipcode = zipcode
        self.birthday = birthday
        self.email = email
        self.password = password
    }

}