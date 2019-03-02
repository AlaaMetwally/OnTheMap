//
//  TextFieldViewController.swift
//  OnTheMap
//
//  Created by Geek on 2/24/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController{
    
    let locationData = ParseStudent()
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Singleton.sharedInstance.students?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = Singleton.sharedInstance.students![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        cell.textLabel?.text = student.fullName
        cell.detailTextLabel?.text = student.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = Singleton.sharedInstance.students![indexPath.row]
        if let url = NSURL(string: student.mediaURL){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}
