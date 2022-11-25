//
//  CreateAccountViewController.swift
//  RegistrationsApp
//
//  Created by dzmitry on 16.11.22.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet private var emailTF: UITextField!
    @IBOutlet private var errorEmailLbl: UILabel!
    
    @IBOutlet private var nameTF: UITextField!
    
    @IBOutlet private var passwordTF: UITextField!
    @IBOutlet private var errorPassLbl: UILabel!
    

    @IBOutlet var strongPassIndicatorsViews: [UIView]!
    @IBOutlet private var confPassTF: UITextField!
    @IBOutlet private var errorConfPassLbl: UILabel!
    
    @IBOutlet private var continueBtn: UIButton!
    
    @IBOutlet private var scrollView: UIScrollView!
    
    // MARK: - Properties
    
    private var isValidEmail = false { didSet { updateContinueBtnState() }}
    private var isConfPass = false { didSet { updateContinueBtnState() }}
    private var passwordStrength: PasswordStrength = .veryWeak { didSet { updateContinueBtnState() }}
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
    }
    
    // MARK: - IBActions
    
    @IBAction func emailTFAction(_ sender: UITextField) {
        if let email = sender.text, !email.isEmpty,
           VerificationService.isValidEmail(email: email) {
            isValidEmail = true
        } else {
            isValidEmail = false
        }
        errorEmailLbl.isHidden = isValidEmail
    }
        
    @IBAction func passTFAction(_ sender: UITextField) {
        if let passText = sender.text, !passText.isEmpty {
            passwordStrength = VerificationService.isValidPassword(pass: passText)
        } else {
            passwordStrength = .veryWeak
        }
        errorPassLbl.isHidden = passwordStrength != .veryWeak
        sutupStrongPassIndicatorsViews()
    }
        
    @IBAction func confPassTFAction(_ sender: UITextField) {
        if let confPassText = sender.text, !confPassText.isEmpty,
           let passText = passwordTF.text, !passText.isEmpty {
            isConfPass = VerificationService.isPassConfirm(pass1: passText,
                                                           pass2: confPassText)
        } else {
            isConfPass = false
        }
        errorConfPassLbl.isHidden = isConfPass
    }
        
    @IBAction func signInBtnAction() {
        navigationController?.popViewController(animated: true)
    }
        
    @IBAction func continueBtnAction() {
        if let email = emailTF.text,
           let pass = passwordTF.text {
            let userModel = UserModel(name: nameTF.text, email: email, pass: pass)
            performSegue(withIdentifier: "goToSecretCodeVC", sender: userModel)
        }
    }
    
    // MARK: - Private Func-s
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide),
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
    
    @objc private func kbWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let contentInsets = UIEdgeInsets(top: 0.0,
                                         left: 0.0,
                                         bottom: keyboardSize.height,
                                         right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc private func kbWillHide() {
        let contentInsets = UIEdgeInsets(top: 0.0,
                                         left: 0.0,
                                         bottom: 0.0,
                                         right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    private func updateContinueBtnState() {
        continueBtn.isEnabled = isValidEmail && isConfPass &&
        passwordStrength != .veryWeak
    }
    
    private func sutupStrongPassIndicatorsViews() {
        strongPassIndicatorsViews.enumerated().forEach { index, view in
            if index <= (passwordStrength.rawValue - 1) {
                view.alpha = 1
            } else {
                view.alpha = 0.25
            }
        }
    }
    
     // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard let destVC = segue.destination as? SecretCodeViewController,
               let userModel = sender as? UserModel else { return }
             destVC.userModel = userModel
     }
    
}

