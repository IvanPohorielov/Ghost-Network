//
//  UserViewController.swift
//  Ghost Network
//
//  Created by MacBook on 08.07.2021.
//

import UIKit

class UserViewController: UIViewController{
    
    
    
    
    @IBOutlet weak var Button: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    @IBAction func buttonDidPressed(_ sender: UIButton) {
        
       fetchUserData()
    }
    
    
    func fetchUserData() {

        let requestHeaders: [String:String] = [
            "Authorization" : "Bearer \(LoginManager.userToken!)" ,
            "Content-Type" : "application/json"
        ]
    
        
        var request = URLRequest(url: URL(string: "https://api.gn.boberneprotiv.com/Users/\(LoginManager.subject!)")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = requestHeaders
        

        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Some error.")
                return
            }
            guard let data = data else { return }
            do {
                let userData = try JSONDecoder().decode(UserData.self, from: data)
                if let firstName = userData.firstName {
                    print(firstName)
                }
                if let dateOfBirth = userData.dateOfBirth {
                    print(dateOfBirth)
                }
            } catch let jsonError {
                print("Fail to decode JSON", jsonError)
            }
        }.resume()
    }
}
