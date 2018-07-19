//
//  SignUp.swift
//  Testing
//
//  Created by EMILENCE on 23/06/18.
//  Copyright © 2018 EMILENCE. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import FirebaseAuth
import MobileCoreServices
import SDWebImage

class SignUp: UIViewController {
    
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    @IBOutlet weak var tf_Username: UITextField!
    @IBOutlet weak var imgVw: UIImageView!
    
    var imgPicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPicker.delegate = self
        
    }

    func loging() {
        self.performSegue(withIdentifier: kHomeSegue, sender: nil)
    }
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


