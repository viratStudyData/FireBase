//
//  SignUp.swift
//  Testing
//
//  Created by EMILENCE on 22/06/18.
//  Copyright © 2018 EMILENCE. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeVC: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tblVw: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.LogOut(notification:)), name: Notification.Name("Logout"), object: nil)
    }

    @IBAction func loggedOutTabbed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            Utility_GlobleAction.showAlert("Logout!", message: "Are you sure?", viewController: self, OtherButtons: ["No", "Yes"], type: "logout")
            
        }catch let firebaseError as NSError {
            Utility_GlobleAction.showAlert("Error", message: firebaseError.localizedDescription, viewController: self, OtherButtons: ["Ok"], type: "simple")
        }
    }
    @objc func LogOut(notification: NSNotification) {
       
        if self.navigationController != nil {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: SignIn.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }else {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SignIn") as! SignIn
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = obj
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
      
    }
    
    //MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
