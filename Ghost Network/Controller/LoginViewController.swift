//
//  LoginViewController.swift
//  Ghost Network
//
//  Created by MacBook on 06.07.2021.
//

import UIKit
import JWTDecode

class LoginViewController: UIViewController{
    
    var loginManager = LoginManager()
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        emailTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        loginButton.layer.cornerRadius = 15
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func loginDidPressed(_ sender: UIButton) {
        if let userName = emailTextField.text, let password = passwordTextField.text {
            loginManager.getToken(userName: userName, password: password) {(userToken, userCode, error) in
                if error != nil {
                    SharedClass.sharedInstance.alert(view: self, title: "Error", message: "Please check your password and email!")
                } else {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "TabBarController", sender: self)
                    }
                }
            }
        }
    }
    
    @IBAction func signUpDidPressed(_ sender: UIButton) {
        print(LoginManager.subject!)
        print("--------------------")
        print(LoginManager.userToken!)
    }
    
    
}

