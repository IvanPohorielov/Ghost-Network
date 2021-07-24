//
//  NewPostManager.swift
//  Ghost Network
//
//  Created by MacBook on 24.07.2021.
//

import Foundation

class NewPostManager {
    
    func newPost(userToken: String, postContent: String) {
        
        let requestHeaders: [String:String] = ["Authorization" : "Bearer \(userToken)",
                                               "Content-Type" : "application/json"]
        let body = NewPost(content: postContent)
        
        var request = URLRequest(url: URL(string: "https://api.gn.boberneprotiv.com/NewsFeed")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = try! JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print("Some error.")
                return
            } else {
                guard let data = data else { return }
                let string = String(decoding: data, as: UTF8.self)
                print(string)
            }
        }.resume()
    }
    
    
}
