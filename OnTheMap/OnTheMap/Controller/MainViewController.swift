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
    var parseStudent = ParseStudent()
    var onTheMapConvenience = OnTheMapConvenience()
    
    @IBAction func pin(sender: UIBarButtonItem) {

        if Singleton.sharedInstance.student == nil {
             createAlert(title: "", message: "Would You Like To Set Your Current Location?")
        }
        else{
            createAlert(title: "", message: "You Have Already Posted a Student Location.Would You Like To Overwrite Your Current Location?")
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        (self.viewControllers![0] as! PinViewController).refresh()
         (self.viewControllers![1] as! TableViewController).refresh()
    }
    
    @IBAction func logout(){
        onTheMapConvenience.deleteSession{
            performUIUpdatesOnMain {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! UIViewController
                self.present(controller, animated: true, completion: nil)

            }
        }
    }
}
