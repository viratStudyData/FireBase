//
//  Extentions.swift
//  Testing
//
//  Created by EMILENCE on 07/07/18.
//  Copyright © 2018 EMILENCE. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase

extension SignUp: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    //MARK: Add Picture With Image Picker Delegates
    func openGallery(alert: UIAlertAction) {
        imgPicker.allowsEditing = true
        imgPicker.sourceType = .photoLibrary
        imgPicker.mediaTypes = [kUTTypeImage as String]
        present(imgPicker, animated: true, completion: nil)
    }
    
    func openCamera(alert: UIAlertAction){
        imgPicker.allowsEditing = true
        imgPicker.sourceType = .camera
        imgPicker.mediaTypes = [kUTTypeImage as String]
        imgPicker.modalPresentationStyle = .popover
        present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImg: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImg = editedImage
            
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImg = originalImage
            
        }
        
        if let img = selectedImg {
            imgVw.image = img
        }
        
        dismiss(animated:true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func addImageTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil,message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let galleryAction = UIAlertAction(title:"Gallery", style:.default, handler:openGallery)
        let cameraAction = UIAlertAction(title:"Camera", style:.default, handler:openCamera)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
