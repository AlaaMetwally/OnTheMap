//
//  Singleton.swift
//  OnTheMap
//
//  Created by Geek on 2/22/19.
//  Copyright © 2019 Geek. All rights reserved.
//
import Foundation

class Singleton {
    
    var student: Student? = nil
    var students: [Students]? = [Students]()
    
    static let sharedInstance: Singleton = Singleton()
    
}
