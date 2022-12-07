//
//  SecretCodeViewController.swift
//  RegistrationsApp
//
//  Created by dzmitry on 21.11.22.
//

import UIKit

class SecretCodeViewController: UIViewController {
    
    var userModel: UserModel?
    var randomInt = Int.random(in: 100000 ... 999999)
    var sleepTime = 3
    
    @IBOutlet weak var secretCodeLabel: UILabel!
    @IBOutlet weak var enterCodeTextField: UITextField!
    @IBOutlet weak var errorCodeLbl: UILabel!
    
    @IBOutlet weak var verticallyConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        registerForKeyboardNotifications()
        addDoneButtonTo(enterCodeTextField)
    }
    
    @IBAction private func codeTFAction(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty,
              text == randomInt.description
        else {
            errorCodeLbl.text = "Error code. Please wait \(sleepTime) seconds"
            sender.isUserInteractionEnabled = false
            errorCodeLbl.isHidden = false
            let dispachAfter = DispatchTimeInterval.seconds(sleepTime)
            let deadline = DispatchTime.now() + dispachAfter
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                sender.isUserInteractionEnabled = true
                self.errorCodeLbl.isHidden = true
                self.sleepTime *= 2
            }
            return
        }
        performSegue(withIdentifier: "goToWelcomVC", sender: nil)
    } 
    
    private func setupUI() {
        secretCodeLabel.text = "Please enter code '\(randomInt)' from \(userModel?.email ?? "")"
    }
    
    // MARK: - Keyboard
    
    private func addDoneButtonTo(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        textField.inputAccessoryView = keyboardToolbar
        keyboardToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDone))
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }
    
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
        guard let keyboardSize = (notification.userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        verticallyConstraint.constant -= keyboardSize.height / 2
    }

    @objc private func kbWillHide(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        verticallyConstraint.constant += keyboardSize.height / 2
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? WelcomeViewController else { return }
            destVC.userModel = userModel
    }

}
