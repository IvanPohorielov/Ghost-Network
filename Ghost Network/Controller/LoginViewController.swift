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
        
    }
    
    @IBAction func loginDidPressed(_ sender: UIButton) {
        if let userName = emailTextField.text, let password = passwordTextField.text {
            loginManager.getToken(userName: userName, password: password) {(userToken, userCode, error) in
                LoginManager.subject = userCode
                LoginManager.userToken = userToken
                if error != nil {
                    SharedClass.sharedInstance.alert(view: self, title: "Error", message: "Please check your password and email!")
                } else {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "UserViewController", sender: self)
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


//    loginManager.login(userName: userName, password: password)
//} else {
//    self.performSegue(withIdentifier: "UserViewController", sender: self)
//}
