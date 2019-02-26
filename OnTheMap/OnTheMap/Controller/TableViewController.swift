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
    
    let locationData = PinViewController()
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationData.hardCodedLocationData().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = locationData.hardCodedLocationData()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        cell.textLabel?.text = student["firstName"] as! String
        cell.detailTextLabel?.text = student["mediaURL"] as! String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = locationData.hardCodedLocationData()[indexPath.row]
        if let url = NSURL(string: student["mediaURL"] as! String){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}
