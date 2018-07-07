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
    }

    @IBAction func loggedOutTabbed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        }catch let error as NSError {
            print (error.localizedDescription)
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
