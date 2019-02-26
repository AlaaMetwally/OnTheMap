//
//  Student.swift
//  OnTheMap
//
//  Created by Geek on 2/26/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import Foundation

struct Student{
    var uniqueKey: String
    var firstName: String
    var lastName: String
    
    var fullName: String{
        return "\(firstName) \(lastName)"
    }
    
    init(dictionary: [String:AnyObject]) {
        uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        firstName = dictionary["firstName"] as? String ?? ""
        lastName = dictionary["lastName"] as? String ?? ""
    }
}
