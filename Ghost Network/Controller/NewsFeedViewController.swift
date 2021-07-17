//
//  NewsFeedViewController.swift
//  Ghost Network
//
//  Created by MacBook on 17.07.2021.
//

import UIKit

class NewsFeedViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {

        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        posts = []
        fetchNewsFeed()
    }
    var posts: [PostData] = []
    
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
                    if let content = post.content, let author = post.author {
                        let newPost = PostData(content: content, author: author)
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
        cell.contentLabel?.text = posts[indexPath.row].content
        cell.fullNameLabel?.text = posts[indexPath.row].author?.fullName
        return cell
    }
    
}
