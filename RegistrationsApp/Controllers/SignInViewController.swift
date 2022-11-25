//
//  SignInViewController.swift
//  RegistrationsApp
//
//  Created by dzmitry on 16.11.22.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaultsService.getUserModel() != nil {
            performSegue(withIdentifier: "goToMainTBVC", sender: nil)
        }
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func signInAction() {
        errorLbl.isHidden = true
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let userModel = UserDefaultsService.getUserModel(),
              email == userModel.email,
              password == userModel.pass
        else {
            errorLbl.isHidden = false
            return
        }
        performSegue(withIdentifier: "goToMainTBVC", sender: nil)
    }
}


