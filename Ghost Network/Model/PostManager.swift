//
//  PostManager.swift
//  Ghost Network
//
//  Created by MacBook on 20.07.2021.
//

import UIKit

class PostManager {
    
    

    
    
    
    
    
    
    
//    [
//      {
//        "id": "string",
//        "content": "string",
//        "comments": {
//          "topComments": [
//            {
//              "id": "string",
//              "content": "string",
//              "publicationId": "string",
//              "author": {
//                "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
//                "fullName": "string",
//                "avatarUrl": "string"
//              },
//              "createdOn": "2021-07-20T16:01:53.878Z"
//            }
//          ],
//          "totalCount": 0
//        },
//        "reactions": {
//          "reactions": [
//            0
//          ],
//          "totalCount": 0,
//          "user": {
//            "type": 0
//          }
//        },
//        "author": {
//          "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
//          "fullName": "string",
//          "avatarUrl": "string"
//        }
//      }
//    ]
//
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    func fetchNewsFeed(tableView: UITableView, posts: [PostManager]) {
//        
//        var postsAppend: [PostManager] = posts
//        
//        let requestHeaders: [String:String] = [
//            "Authorization" : "Bearer \(LoginManager.userToken!)" ,
//            "Content-Type" : "application/json"
//        ]
//        
//        
//        var request = URLRequest(url: URL(string: "https://api.gn.boberneprotiv.com/NewsFeed")!)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = requestHeaders
//        
//        
//        
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if error != nil {
//                print("Some error.")
//                return
//            }
//            guard let data = data else { return }
//            do {
//                let jsonPosts = try JSONDecoder().decode([PostData].self, from: data)
//                for post in jsonPosts {
//                    if let postId = post.id,
//                       let postContent = post.content,
//                       let authorId = post.author?.id,
//                       let authorFullName = post.author?.fullName  {
//                        let newPost = PostModel(postId: postId,
//                                                postContent: postContent,
//                                                authorId: authorId,
//                                                authorFullName: authorFullName)
//                        
//                        postsAppend.append(newPost)
//                        
//                        DispatchQueue.main.async {
//                            tableView.reloadData()
//                        }
//                    }
//                }
//            } catch {
//                print("Fail to decode JSON")
//            }
//        }.resume()
//    }
}
