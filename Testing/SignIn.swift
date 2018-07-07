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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        
        super.viewWillAppear(animated)
        let user = Auth.auth().currentUser;
        
        if ((user) != nil) {
            print(user!.uid)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "Logout") as! HomeVC
            self.present(obj, animated: true, completion: nil)
            
        }
    }
    @IBAction func actionOnSignIn(_ sender: Any) {
        if let email = tf_Email.text, let password = tf_Password.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                self.loging()
            }
        }        
    }
    @IBAction func actionOnCreateAccount(_ sender: Any) {
        self.performSegue(withIdentifier: "SignUpSegue", sender: nil)
    }
    
    func loging() {
        self.performSegue(withIdentifier: "LogoutSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

