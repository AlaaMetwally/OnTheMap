//
//  ParseStudents.swift
//  OnTheMap
//
//  Created by Geek on 2/26/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import Foundation
import UIKit

class ParseStudent: UIViewController{
    
    var session = URLSession.shared
    var onTheMapConvenience = OnTheMapConvenience()

    func getStudents(completionHandler handler:@escaping([[String:AnyObject]]?) -> Void){
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        onTheMapConvenience.requestHandler(request: request){ (results,error) in
            guard let parsedResult = results!["results"] as? [[String : AnyObject]] else {
                print("Can't find results in response")
                return
            }
            var students: [Students] = []
            
            for result in parsedResult {
                students.append(Students(dictionary: result))
            }
            Singleton.sharedInstance.students = students
            handler(parsedResult)
        }
    }
    func getStudent(student: Students,completionHandler handler:@escaping(Students)->Void){
        let originalString = "{\"uniqueKey\":\"\(student.uniqueKey)\",\"objectId\" : \"\(student.objectId)\"}"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=" + escapedString!
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        onTheMapConvenience.requestHandler(request: request){ (results,error) in
            if let studentData = results!["results"] as? [[String:Any]],
                let student = studentData.first {
                var info = Students(dictionary: student as [String : AnyObject])
                handler(info)
            }
    }
    }
    func postStudent(student: Students,completionHandler handler: @escaping(String)->Void){
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaURL)\",\"latitude\": \(student.latitude), \"longitude\": \(student.longitude)}".data(using: .utf8)
        
        onTheMapConvenience.requestHandler(request: request){ (results,error) in
            guard let objectId = results!["objectId"] else{
                print("there is a problem in object id")
                return
        }
            guard error != nil else {
                print("Could not post student")
                self.errorMessageAlert(title: "", message: "Could not post student")
                return
            }
            handler(objectId as! String)
    }
}
    func putStudent(student: Students,completionHandler handler:@escaping(Students)->Void){
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(student.objectId)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaURL)\",\"latitude\": \(student.latitude), \"longitude\": \(student.longitude)}".data(using: .utf8)
        
        onTheMapConvenience.requestHandler(request: request){ (results,error) in
            self.getStudent(student: student){(studentData) in
                handler(studentData)
            }
    }
    }
}
