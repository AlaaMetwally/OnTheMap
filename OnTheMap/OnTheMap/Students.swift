//
//  Students.swift
//  OnTheMap
//
//  Created by Geek on 2/26/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import Foundation

struct Students{
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    
    var fullName: String{
        return "\(firstName) \(lastName)"
    }
    
    init(dictionary: [String:AnyObject]) {
        objectId = dictionary["objectId"] as? String ?? "123"
         uniqueKey = dictionary["uniqueKey"] as? String ?? "123"
         firstName = dictionary["firstName"] as? String ?? "123"
         lastName = dictionary["lastName"] as? String ?? "123"
         mapString = dictionary["mapString"] as? String ?? "123"
         mediaURL = dictionary["mediaURL"] as? String ?? "123"
         latitude = dictionary["latitude"] as? Double ?? 0
         longitude = dictionary["longitude"] as? Double ?? 0
    }
}
