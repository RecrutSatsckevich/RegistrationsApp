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
        registerForKeyboardNotifications()
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
    
    // MARK: - Keyboard

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[
            UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                let height = keyboardSize.height
                self.view.frame.origin.y -= height / 3
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[
            UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                let height = keyboardSize.height
                self.view.frame.origin.y += height / 3
            }
        }
    }
}



