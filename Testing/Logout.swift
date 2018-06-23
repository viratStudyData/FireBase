//
//  SignUp.swift
//  Testing
//
//  Created by EMILENCE on 22/06/18.
//  Copyright © 2018 EMILENCE. All rights reserved.
//

import UIKit
import FirebaseAuth

class Logout: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loggedOutTabbed(_ sender: Any) {
        do
        {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        }
        catch let error as NSError
        {
            print (error.localizedDescription)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
