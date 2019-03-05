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
    
    var password = PasswordTextFieldDelegate()
    var keyboardOnScreen = false
    var onTheMapConvenience = OnTheMapConvenience()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = password
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
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
                self.completeLogin()
        }
    }
}
extension LoginViewController{
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if emailTextField.isEditing || passwordTextField.isEditing{
            view.frame.origin.y -= getKeyboardHeight(notification)/2
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}
extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
