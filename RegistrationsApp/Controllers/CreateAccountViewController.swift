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
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        //errorConfPassLbl.text = "Repeat your password, please"
    }
        
    @IBAction func signInBtnAction() {
        navigationController?.popViewController(animated: true)
    }
        
    @IBAction func continueBtnAction() {
        let storyboard = UIStoryboard(name: "SignUpStoryboard", bundle: nil)
        if let secretCodeVC = storyboard.instantiateViewController(withIdentifier: "SecretCodeViewController") as? SecretCodeViewController {
            secretCodeVC.str = "255737"
            navigationController?.pushViewController(secretCodeVC, animated: true)
        }
    }
    
    // MARK: - Private Func-s
    
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

    // MARK: - Keyboard + ScrollView
    
    deinit {
        removeKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }

    @objc func kbWillHide(_ notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
    
    // метод закрытия клавиатуры
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // // MARK: - Navigation
    //
    // // In a storyboard-based application, you will often want to do a little preparation before navigation
    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    // Get the new view controller using segue.destination.
    //    // Pass the selected object to the new view controller.
    // }

}

