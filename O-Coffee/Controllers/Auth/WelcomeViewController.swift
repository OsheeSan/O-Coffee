//
//  WelcomeViewController.swift
//  O-Coffee
//
//  Created by admin on 05.05.2023.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//                do {
//                    try Auth.auth().signOut()
//                } catch  {
//
//                }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "Login", sender: self)
        } else {
            performSegue(withIdentifier: "Active", sender: self)
        }
        
    }

}
