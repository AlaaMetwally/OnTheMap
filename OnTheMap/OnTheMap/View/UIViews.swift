//
//  UIViews.swift
//  OnTheMap
//
//  Created by Geek on 2/26/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title,message: message,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapViewController") 
            self.present(controller, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
