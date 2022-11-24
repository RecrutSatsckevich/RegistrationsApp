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
    
    @IBOutlet weak var verticallyConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
//        registerForKeyboardNotifications()
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
    }
    
    
//    private func registerForKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow),
//                                               name: UIResponder.keyboardWillShowNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide),
//                                               name: UIResponder.keyboardWillHideNotification,
//                                               object: nil)
//    }
//
//    private func removeKeyboardNotifications() {
//        NotificationCenter.default.removeObserver(self,
//                                                  name: UIResponder.keyboardWillShowNotification,
//                                                  object: nil)
//        NotificationCenter.default.removeObserver(self,
//                                                  name: UIResponder.keyboardWillHideNotification,
//                                                  object: nil)
//    }
//
//    @objc private func kbWillShow(_ notification: Notification) {
//        guard let keyboardSize = (notification.userInfo?[
//            UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//        }
//        verticallyConstraint.constant -= keyboardSize.height / 2
//    }
//
//    @objc private func kbWillHide(_ notification: Notification) {
//        guard let keyboardSize = (notification.userInfo?[
//            UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//        }
//        verticallyConstraint.constant += keyboardSize.height / 2
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


