//
//  LoginViewController.swift
//  Ghost Network
//
//  Created by MacBook on 06.07.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        emailTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        loginButton.layer.cornerRadius = 15
    }
    
}
