//
//  UserViewController.swift
//  Ghost Network
//
//  Created by MacBook on 08.07.2021.
//

import UIKit

class UserViewController: UIViewController{
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
        avatarImage.layer.borderWidth = 1.0
        avatarImage.layer.masksToBounds = false
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width/2
        avatarImage.clipsToBounds = true
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
                
                DispatchQueue.main.async {
                    if let firstName = userData.firstName {
                        self.firstNameLabel.text = firstName
                        //print(firstName)
                    } else {
                        print("error")
                    }
                    if let lastName = userData.lastName {
                        self.lastNameLabel.text = lastName
                        //print(lastName)
                    } else {
                        print("error")
                    }
                    if let dateOfBirth = userData.dateOfBirth {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let formattedDate = formatter.date(from: dateOfBirth)
                        let formatter1 = DateFormatter()
                        formatter1.dateFormat = "MMM d, yyyy"
                        let dateString = formatter1.string(from: formattedDate!)
                        let age = self.getAge(date: formattedDate!)
                        
                        self.ageLabel.text =  "\(dateString) (\(age) y.o.)"
                    
                    } else {
                        print("error")
                    }
                }
                
            } catch let jsonError {
                print("Fail to decode JSON", jsonError)
            }
        }.resume()
    }
    
    func getAge(date: Date) -> Int {
    let calendar = Calendar.current
    let dateComponent = calendar.dateComponents([.year], from:
       date, to: Date())
        
        return (dateComponent.year!)
    }

    func fetchUserNewsFeed() {
        
    }
}
