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
    @IBOutlet weak var avatarImage: RoundedImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchUserData()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")

        posts = []
        fetchUserNewsFeed()
        
    }
    
    let userManager = UserManager()
    let userPostManager = UserNewsManager()

    // Getting user data
    
    func fetchUserData() {
 
        userManager.fetch(userId: LoginManager.subject!) { (firstName, lastName, dateOfBirth, age) in
            DispatchQueue.main.async {
                self.firstNameLabel.text = firstName
                self.lastNameLabel.text = lastName
                self.ageLabel.text =  "\(dateOfBirth) (\(age) y.o.)"
            }
        }
    }
    
    // Getting posts
    
    var posts: [PostModel] = []
    
    func fetchUserNewsFeed() {
        
        userPostManager.fetch(userId: LoginManager.subject!) { postNewsFeed in
            self.posts = postNewsFeed
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
//MARK: - TableView DataSource

extension UserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userPostCell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! PostCell
        
        if posts[indexPath.row].authorId == LoginManager.subject {
            userPostCell.deleteButton.isHidden = false
            
        } else {
            userPostCell.deleteButton.isHidden = true
        }
        
        userPostCell.delegate = self
        
        userPostCell.contentLabel?.text = posts[indexPath.row].postContent
        userPostCell.fullNameLabel?.text = posts[indexPath.row].authorFullName
        return userPostCell
    }
    
}
//MARK: - MyCellDelegate

extension UserViewController: PostCellDelegate {
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
            self.fetchUserNewsFeed()
        }
    }
}
