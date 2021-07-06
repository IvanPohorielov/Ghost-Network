//
//  LoginManager.swift
//  Ghost Network
//
//  Created by MacBook on 06.07.2021.
//

import Foundation
import JWTDecode

protocol LoginManagerDelegate {
    func didUpdateToken(_ token: JWT)
    func didFailWithError(error: Error)
}

struct LoginManager {

    var delegate: LoginManagerDelegate?
    
    func getToken(userName: String, password: String) {
 
    
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
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response,error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                if let token =  parceJSON(safeData) {
                    print(token)
                }
                
            }
            
        }
        .resume()
    }


    func parceJSON(_ data: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LoginData.self, from: data)
            return decodedData.access_token
            
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
