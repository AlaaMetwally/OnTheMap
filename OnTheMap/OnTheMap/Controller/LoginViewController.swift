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
    
    var password = PasswordTextFieldDelegate()
    var keyboardOnScreen = false
    var onTheMapConvenience = OnTheMapConvenience()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = password
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
 
    @IBAction func register(_ sender: Any) {
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup"){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    public func completeLogin() {
        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func login(_ sender: Any){
        onTheMapConvenience.postSession(email: self.emailTextField.text!,password: self.passwordTextField.text!){
            (parsedResult: [String:AnyObject],error: String?) in
            
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
    }
}
extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
