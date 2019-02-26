//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Geek on 2/19/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    let password = PasswordTextFieldDelegate()
    
    var keyboardOnScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = password
        
        subscribeToNotification(UIResponder.keyboardWillShowNotification,selector: #selector(keyboardWilShow))
        subscribeToNotification(UIResponder.keyboardWillHideNotification,selector:#selector(keyboardWilHide))
        subscribeToNotification(UIResponder.keyboardDidShowNotification,selector:#selector(keyboardDidShow))
        subscribeToNotification(UIResponder.keyboardDidHideNotification,selector:#selector(keyboardDidHide))
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.debugLabel.text = ""
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func register(_ sender: Any) {
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup"){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    @IBAction func login(_ sender: Any){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody =
            "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            guard let account =  parsedResult["account"] else{
                performUIUpdatesOnMain{
                 self.debugLabel.text = "You aren\'t registered"
                }
                 return
            }
            guard let register = parsedResult["account"]!["registered"] else{
                performUIUpdatesOnMain{
                 self.debugLabel.text = "You aren\'t registered"
                }
                return
            }
            self.completeLogin()
        }
        task.resume()
    }
}
extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWilShow(_ notification: Notification){
        
    }
    @objc func keyboardWilHide(_ notification: Notification){
        
    }
    @objc func keyboardDidShow(_ notification: Notification){
        keyboardOnScreen = true
    }
    @objc func keyboardDidHide(_ notification: Notification){
        keyboardOnScreen = false
    }
}
extension LoginViewController{
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector){
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    func unsubscribeFromAllNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
}
