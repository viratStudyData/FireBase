//
//  ViewController.swift
//  Testing
//
//  Created by EMILENCE on 21/06/18.
//  Copyright © 2018 EMILENCE. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import FirebaseAuth

class SignIn: UIViewController {

    var ref: DatabaseReference!
    
    @IBOutlet weak var tf_Username: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
    }
    @IBAction func actionOnSignIn(_ sender: Any) {
        if let email = tf_Username.text, let password = tf_Password.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                self.performSegue(withIdentifier: "LogoutSegue", sender: nil)
            }
        }
       
        
    }
    @IBAction func actionOnCreateAccount(_ sender: Any) {
        if let email = tf_Username.text, let password = tf_Password.text {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
               self.performSegue(withIdentifier: "LogoutSegue", sender: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

