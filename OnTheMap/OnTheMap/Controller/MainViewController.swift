//
//  MainCiewController.swift
//  OnTheMap
//
//  Created by Geek on 2/23/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    @IBOutlet weak var LogoutButton: UIBarButtonItem!
    @IBOutlet weak var pin: UIBarButtonItem!
    
    @IBAction func pin(sender: UIBarButtonItem) {
        
        let originalString = "{\"uniqueKey\":\"1234\"}"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=" + escapedString!
        print(urlString)
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        print(request)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    @IBAction func logout(){
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
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            performUIUpdatesOnMain {
                self.dismiss(animated: true, completion: nil)
            }
        }
        task.resume()
    }
}
