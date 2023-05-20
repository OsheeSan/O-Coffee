//
//  RegisterViewController.swift
//  O-Coffee
//
//  Created by admin on 05.05.2023.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var RepeatPasswordTextField: UITextField!
    
    @IBAction func SignUpButtonTouched(_ sender: RoundedButton) {
        guard checkTextFields() else {
            return
        }
        print("Checked")
        Auth.auth().createUser(withEmail: EmailTextField.text!, password: PasswordTextField.text!){ response,error in
            guard error == nil else {
                print(error)
                return
            }
            print("Created")
            Auth.auth().signIn(withEmail: self.EmailTextField.text!, password: self.PasswordTextField.text!) { response, error in
                guard error == nil else {
                    print(error)
                    return
                }
                guard let userId = Auth.auth().currentUser?.uid else {
                    return
                }

                RTDataBaseManager.shared.addUserToDatabase(userId: userId, email: self.EmailTextField.text!, username: self.UsernameTextField.text!)
                self.navigationController?.dismiss(animated: true)
            }
        }
    }
    
    private func checkTextFields() -> Bool
    {
        guard !UsernameTextField.text!.isEmpty, !EmailTextField.text!.isEmpty, !PasswordTextField.text!.isEmpty,!RepeatPasswordTextField.text!.isEmpty else {
            showAlert(title: "Oops!", message: "Some cells are empty")
            return false
        }
        guard PasswordTextField.text! == RepeatPasswordTextField.text! else {
            showAlert(title: "Carefull!", message: "Passwords are not identical")
            return false
        }
        guard PasswordTextField.text!.count >= 6 else {
            showAlert(title: "Carefull!", message: "The password must be 6 characters long or more.")
            return false
        }
        return true
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
