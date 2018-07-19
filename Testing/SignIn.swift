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
import MobileCoreServices
import SDWebImage

class SignIn: UIViewController {

    var ref: DatabaseReference!
    
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.checkIfUserIsLoggedIn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func actionOnSignIn(_ sender: Any) {
        if let email = tf_Email.text, let password = tf_Password.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let firebaseError = error {
                    Utility_GlobleAction.showAlert("Error", message: firebaseError.localizedDescription, viewController: self, OtherButtons: ["Ok"], type: "Simple")
                    return
                }
                self.loging()
            }
        }        
    }
    @IBAction func actionOnCreateAccount(_ sender: Any) {
        self.performSegue(withIdentifier: kSignUpSegue, sender: nil)
    }
    
    func loging() {
        self.performSegue(withIdentifier: kHomeSegue, sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

