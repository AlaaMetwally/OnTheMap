//
//  OnTheMapConvenience.swift
//  OnTheMap
//
//  Created by Geek on 2/26/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import Foundation

class OnTheMapConvenience{
    var session = URLSession.shared
    var userId: String? = nil
    
    func postSession(email: String, password: String ,completionHandler handler: @escaping (_ parsedResult: [String:AnyObject],_ error: String?) -> Void){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody =
            "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        requestHandler(request: request){ (results,error) in
            guard let account = results!["account"] else{
                print("no account")
                return
            }
            guard let uniqueKey = account["key"] else{
                print("unique key")
                return
            }
            self.userId = uniqueKey as! String
            handler(results!, nil)
        }
    }
    func deleteSession(completionHandler handler:@escaping ()->Void){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        requestHandler(request: request){ (results,error) in
            handler()
        }
    }
    
    func getUserData(completionHandler hander: @escaping(_ result: Student) -> Void){
        let url = URL(string: "https://onthemap-api.udacity.com/v1/users/\(self.userId)")
        let request = URLRequest(url: url!)
        requestHandler(request: request){ (results,error) in
            var student = Student(dictionary: results!)
            guard let firstName = results!["first_name"], let lastName = results!["last_name"],let uniqueKey = results!["key"]
                else{
                print("data of student not found")
                return
            }
            student.firstName = firstName as! String
            student.lastName = lastName as! String
            student.uniqueKey = uniqueKey as! String
            Singleton.sharedInstance.student = student
            hander(student)
        }
    }
    
    func requestHandler(request: URLRequest,completionHandler handler:@escaping (_ result:  [String : AnyObject]?,_ error: String?) -> Void){
        
        let task = session.dataTask(with: request) { data, response, error in
            
            func displayError(_ error: String) {
                print(error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
           
            /* 5. Parse the data */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try (JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject])
                handler(parsedResult,nil)
            } catch {
                do{
                    let range = 5..<data.count
                    let newData = data.subdata(in: range) /* subset response data! */
                    parsedResult = try (JSONSerialization.jsonObject(with: newData, options: .allowFragments) as? [String:AnyObject])
                    handler(parsedResult,nil)
                }catch{
                    displayError("Could not parse the data as JSON: '\(data)'")
                    return
                }
            }
            
        }
        task.resume()
    }
}
