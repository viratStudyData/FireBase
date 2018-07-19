//
//  Utility+GlobleAction.swift
//  Testing
//
//  Created by EMILENCE on 11/07/18.
//  Copyright © 2018 EMILENCE. All rights reserved.
//

import UIKit

class Utility_GlobleAction: NSObject {

    // MARK: AlertController
    class func showAlert(_ title: String!, message: String!, viewController: UIViewController, OtherButtons: [String], type: String!) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        for name in OtherButtons {
            alert.addAction(UIAlertAction(title: name, style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in print(name)
                
                if name == "Yes" {
                    Yes(type: type, controller: viewController)
                }else if name == "Ok" {
                    Ok(type: type, controller: viewController)
                }
            }))
            
        }
        
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
    class func Yes(type: String, controller: UIViewController) {
        if type == "logout" {
            controller.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Logout"), object: nil)
        }
    }
    
    class func Ok(type: String, controller: UIViewController){
        if type == "SignUp" {
            
        }else if type == "Back" {
            _ = controller.navigationController?.popViewController(animated: true)
        }
    }
}
