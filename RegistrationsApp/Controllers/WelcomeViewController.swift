//
//  WelcomeViewController.swift
//  RegistrationsApp
//
//  Created by dzmitry on 24.11.22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var userModel: UserModel?

    @IBOutlet weak var infoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func saveUserDateAndContinueAction() {
        guard let userModel = userModel else { return }
        UserDefaultsService.saveUserModel(userModel: userModel)
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupUI() {
        infoLbl.text = "\(userModel?.name ?? "") to our Cool App "
    }
}
