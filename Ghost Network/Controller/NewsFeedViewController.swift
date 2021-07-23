//
//  NewsFeedViewController.swift
//  Ghost Network
//
//  Created by MacBook on 17.07.2021.
//

import UIKit

class NewsFeedViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newPostButton: UIButton!
    
    let postManager = UserNewsPostManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        newPostButton.layer.cornerRadius = 30
        newPostButton.layer.shadowRadius = 10
        newPostButton.layer.shadowOpacity = 0.5

      
        
        posts = []
        fetchNewsFeed()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        posts = []
//    }

//MARK: - FetchNewsFeed
    
    var posts: [PostModel] = []
    static var postId: String?
    static var postContent: String?
    static var authorId: String?
    static var authorFullName: String?
    
    func fetchNewsFeed() {

        let requestHeaders: [String:String] = [
            "Authorization" : "Bearer \(LoginManager.userToken!)" ,
            "Content-Type" : "application/json"
        ]


        var request = URLRequest(url: URL(string: "https://api.gn.boberneprotiv.com/NewsFeed")!)
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
                for post in posts {
                    if let postId = post.id,
                       let postContent = post.content,
                       let authorId = post.author?.id,
                       let authorFullName = post.author?.fullName  {
                        let newPost = PostModel(postId: postId,
                                                postContent: postContent,
                                                authorId: authorId,
                                                authorFullName: authorFullName)
                        NewsFeedViewController.postId = postId
                        NewsFeedViewController.postContent = postContent
                        NewsFeedViewController.authorId = authorId
                        NewsFeedViewController.authorFullName = authorFullName

                        self.posts.append(newPost)

                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            } catch {
                print("Fail to decode JSON")
            }
        }.resume()
    }
    
}
//MARK: - TableView DataSource

extension NewsFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! PostCell

        if posts[indexPath.row].authorId == LoginManager.subject {
            cell.deleteButton.isHidden = false
        } else {
            cell.deleteButton.isHidden = true
        }
        cell.delegate = self
        
        
        cell.contentLabel?.text = posts[indexPath.row].postContent
        cell.fullNameLabel?.text = posts[indexPath.row].authorFullName
        return cell
    }
}
//MARK: - MyCellDelegate

extension NewsFeedViewController: PostCellDelegate {
    func didTap(_ cell: PostCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        deletePost(postId: posts[indexPath!.row].postId!)
    }
    
    func deletePost(postId: String) {
        let requestHeaders: [String:String] = ["Authorization" : "Bearer \(LoginManager.userToken!)",
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            self.posts = []
            self.fetchNewsFeed()
        }
    }
}
