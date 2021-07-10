//
//  LoginManager.swift
//  Ghost Network
//
//  Created by MacBook on 06.07.2021.
//

import Foundation
import JWTDecode

class LoginManager {
    
    static var userToken: String? 
    static var subject: String?
    static var error: Error?
    

    
    func login(userName: String, password: String) {
        getToken(userName: userName, password: password) { (userToken, userCode, error) in
            LoginManager.subject = userCode!
            LoginManager.userToken = userToken!
        }
   }
    
    
    func getToken(userName: String, password: String, completion: @escaping (String?, String?, Error?) -> Void) {
        
        let requestHeaders: [String:String] = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "ios_app"),
            URLQueryItem(name: "client_secret", value: "temp_secret"),
            URLQueryItem(name: "grant_type", value: "password"),
            URLQueryItem(name: "username", value: userName),
            URLQueryItem(name: "password", value: password)
        ]
        
        
        var request = URLRequest(url: URL(string: "https://account.gn.boberneprotiv.com/connect/token")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print("Some error.")
                completion(nil, nil, error)
                return
            }
            guard let data = data else { return }
            do {
                let token = try JSONDecoder().decode(LoginData.self, from: data)
                let jwt = try decode(jwt: "\(token.access_token)")
                LoginManager.subject = jwt.subject!
                LoginManager.userToken = token.access_token
            
                completion(LoginManager.userToken, LoginManager.subject, nil)
            } catch let jsonError {
                print("Fail to decode JSON", jsonError)
                completion(nil, nil, jsonError)
            }
        }
        .resume()
        
    }
}
