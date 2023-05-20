//
//  LoginViewController.swift
//  O-Coffee
//
//  Created by admin on 05.05.2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    @IBAction func SignInButtonTapped(_ sender: RoundedButton) {
        Auth.auth().signIn(withEmail: self.EmailTextField.text!, password: self.PasswordTextField.text!) { response, error in
            guard error == nil else {
                return
            }
            self.dismiss(animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
