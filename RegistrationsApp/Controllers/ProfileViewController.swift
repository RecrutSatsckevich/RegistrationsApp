//
//  ProfileViewController.swift
//  RegistrationsApp
//
//  Created by dzmitry on 25.11.22.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBAction func logOutAction(_ sender: Any) {
            navigationController?.popToRootViewController(animated: true)
        }
        
        @IBAction func deleteAccountAction() {
            UserDefaultsService.cleanUserDefaults()
            navigationController?.popToRootViewController(animated: true)
        }

}
