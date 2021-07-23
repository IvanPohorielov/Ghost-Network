//
//  UserManager.swift
//  Ghost Network
//
//  Created by MacBook on 23.07.2021.
//

import Foundation

class UserManager {
    
    func fetch(userId: String,  completion: @escaping (String, String, String, Int) -> Void) {
        let requestHeaders: [String:String] = [
            "Authorization" : "Bearer \(LoginManager.userToken!)" ,
            "Content-Type" : "application/json"
        ]
        
        
        var request = URLRequest(url: URL(string: "https://api.gn.boberneprotiv.com/Users/\(userId)")!)
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
                if let firstName = userData.firstName, let lastName = userData.lastName, let dateOfBirth = userData.dateOfBirth {
                   
                    let dateOfBirthString = fetchAge(dateOfBirth: dateOfBirth).0
                    let age = fetchAge(dateOfBirth: dateOfBirth).1
                    
                  completion(firstName, lastName, dateOfBirthString, age)
                } else {
                    print("error")
                }
            } catch let jsonError {
                print("Fail to decode JSON", jsonError)
            }
        }.resume()
        
        func fetchAge(dateOfBirth: String)  -> (String, Int){
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let formattedDate = formatter.date(from: dateOfBirth)
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "MMM d, yyyy"
            let dateOfBirth = formatter1.string(from: formattedDate!)
            let calendar = Calendar.current
            let age = calendar.dateComponents([.year], from: formattedDate!, to: Date())

            return (dateOfBirth, age.year!)
        }
    }
}
