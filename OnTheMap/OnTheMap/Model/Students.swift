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
         objectId = dictionary["objectId"] as? String ?? "objectId"
         uniqueKey = dictionary["uniqueKey"] as? String ?? "uniqueKey"
         firstName = dictionary["firstName"] as? String ?? "firstName"
         lastName = dictionary["lastName"] as? String ?? "lastName"
         mapString = dictionary["mapString"] as? String ?? "mapString"
         mediaURL = dictionary["mediaURL"] as? String ?? "mediaURL"
         latitude = dictionary["latitude"] as? Double ?? 0
         longitude = dictionary["longitude"] as? Double ?? 0
    }
}
