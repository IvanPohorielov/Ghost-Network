//
//  PostManager.swift
//  Ghost Network
//
//  Created by MacBook on 20.07.2021.
//

import UIKit

class UserNewsManager {

    func fetch(userId: String,  completion: @escaping ([PostModel]) -> Void) {
        
        let requestHeaders: [String:String] = [
                   "Authorization" : "Bearer \(LoginManager.userToken!)" ,
                   "Content-Type" : "application/json"
               ]
       
       
               var request = URLRequest(url: URL(string: "https://api.gn.boberneprotiv.com/NewsFeed/users/\(userId)")!)
               request.httpMethod = "GET"
               request.allHTTPHeaderFields = requestHeaders
       
       
       
               URLSession.shared.dataTask(with: request) { (data, response, error) in
                   if error != nil {
                       print("Some error.")
                       return
                   }
                   guard let data = data else { return }
                   do {
                       let posts = try JSONDecoder().decode([PostData].self, from: data)
                    var postsFeedNews: [PostModel] = []
                    for post in posts {
                           if let postId = post.id,
                              let postContent = post.content,
                              let authorId = post.author?.id,
                              let authorFullName = post.author?.fullName  {
                               let newPost = PostModel(postId: postId,
                                                       postContent: postContent,
                                                       authorId: authorId,
                                                       authorFullName: authorFullName)
                        
                            postsFeedNews.append(newPost)
                            
                           }
                        completion(postsFeedNews)
                       }
       
                   } catch {
                       print("Fail to decode JSON")
                   }
       
               }.resume()
      }
    }
