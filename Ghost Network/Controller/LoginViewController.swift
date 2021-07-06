//
//  LoginViewController.swift
//  Ghost Network
//
//  Created by MacBook on 06.07.2021.
//

import UIKit
import JWTDecode

class LoginViewController: UIViewController, LoginManagerDelegate {
   
    func didUpdateToken(_ token: JWT) {
    }
    
    func didFailWithError(error: Error) {
    }
    
    
    var loginManager = LoginManager()
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        emailTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        loginButton.layer.cornerRadius = 15
        loginManager.delegate = self
        
    }
    
    @IBAction func loginDidPressed(_ sender: UIButton) {
        let userName = emailTextField.text
        let password = passwordTextField.text
        loginManager.getToken(userName: userName!, password: password!)
    }
}
