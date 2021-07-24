//
//  DeletePostManager.swift
//  Ghost Network
//
//  Created by MacBook on 24.07.2021.
//

import Foundation

class DeletePostManager {
    func delete(postId: String, userToken: String){
        let requestHeaders: [String:String] = ["Authorization" : "Bearer \(userToken)",
                                                                "Content-Type" : "application/json"]
                         
                         
                         var request = URLRequest(url: URL(string: "https://api.gn.boberneprotiv.com/NewsFeed/\(postId)")!)
                         request.httpMethod = "DELETE"
                         request.allHTTPHeaderFields = requestHeaders
                         
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
