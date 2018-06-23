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

class SignUp: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    @IBOutlet weak var tf_Username: UITextField!
    
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var imgVw: UIImageView!
    var imgPicker = UIImagePickerController()
    var userImg: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgPicker.delegate = self
        
    }

    @IBAction func actionOnCreateAccount(_ sender: Any) {
        if let email = tf_Email.text, let password = tf_Password.text, let userName = tf_Username.text {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                guard let userInfo = user?.user else{
                    return
                }
                print("Succcessfully Authenticate User!")
                let params = ["userName": userName, "email":email]
                let ref = Database.database().reference()
                let userReference = ref.child("user").child(userInfo.uid)
                userReference.updateChildValues(params, withCompletionBlock:{(err, ref) in
                    if err != nil {
                        print(err!.localizedDescription)
                        return
                    }
                    self.loging()
                })
            }
        }
    }
    
    func loging() {
        self.performSegue(withIdentifier: "LogoutSegue", sender: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil,message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let galleryAction = UIAlertAction(title:"Gallery", style:.default, handler:openGallery)
        let cameraAction = UIAlertAction(title:"Camera", style:.default, handler:openCamera)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Add Picture With Image Picker Delegates
    func openGallery(alert: UIAlertAction) {
        imgPicker.allowsEditing = false
        imgPicker.sourceType = .photoLibrary
        imgPicker.mediaTypes = [kUTTypeImage as String]
        present(imgPicker, animated: true, completion: nil)
    }
    
    func openCamera(alert: UIAlertAction){
        imgPicker.allowsEditing = false
        imgPicker.sourceType = .camera
        imgPicker.mediaTypes = [kUTTypeImage as String]
        imgPicker.modalPresentationStyle = .popover
        present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        userImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgVw.contentMode = .scaleToFill
        imgVw.image = userImg
        btnAddImage.setImage(UIImage(named: ""), for: .normal)
        dismiss(animated:true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


