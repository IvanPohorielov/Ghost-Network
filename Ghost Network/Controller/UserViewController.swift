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
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //super .viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        fetchUserData()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        avatarImage.layer.masksToBounds = false
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width/2
        avatarImage.clipsToBounds = true
        
        posts = []
        fetchUserNewsFeed()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    //MARK: - FetchUserData
    
    func fetchUserData() {
        
        let requestHeaders: [String:String] = [
            "Authorization" : "Bearer \(LoginManager.userToken!)" ,
            "Content-Type" : "application/json"
        ]
        
        
        var request = URLRequest(url: URL(string: "https://api.gn.boberneprotiv.com/Users/\(LoginManager.subject!)")!)
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
                
                DispatchQueue.main.async {
                    if let firstName = userData.firstName {
                        self.firstNameLabel.text = firstName
                        //print(firstName)
                    } else {
                        print("error")
                    }
                    if let lastName = userData.lastName {
                        self.lastNameLabel.text = lastName
                        //print(lastName)
                    } else {
                        print("error")
                    }
                    if let dateOfBirth = userData.dateOfBirth {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let formattedDate = formatter.date(from: dateOfBirth)
                        let formatter1 = DateFormatter()
                        formatter1.dateFormat = "MMM d, yyyy"
                        let dateString = formatter1.string(from: formattedDate!)
                        let age = getAge(date: formattedDate!)
                        
                        self.ageLabel.text =  "\(dateString) (\(age) y.o.)"
                        
                    } else {
                        print("error")
                    }
                }
                
            } catch let jsonError {
                print("Fail to decode JSON", jsonError)
            }
        }.resume()
        
        func getAge(date: Date) -> Int {
            let calendar = Calendar.current
            let dateComponent = calendar.dateComponents([.year], from:
                                                            date, to: Date())
            
            return (dateComponent.year!)
        }
        
    }
    
    //MARK: - FetchUserPostData
    
    var posts: [PostData] = [
        //        PostData(content: "Hello", author: Author(fullName: "Borodin")),
        //        PostData(content: "Hello2", author: Author(fullName: "Ivan")),
        //        PostData(content: "Hello3", author: Author(fullName: "Sofia"))
    ]
    
    
    func fetchUserNewsFeed() {
        
        let requestHeaders: [String:String] = [
            "Authorization" : "Bearer \(LoginManager.userToken!)" ,
            "Content-Type" : "application/json"
        ]
        
        
        var request = URLRequest(url: URL(string: "https://api.gn.boberneprotiv.com/NewsFeed/users/\(LoginManager.subject!)")!)
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

extension UserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userPostCell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! PostCell
        userPostCell.contentLabel?.text = posts[indexPath.row].content
        userPostCell.fullNameLabel?.text = posts[indexPath.row].author?.fullName
        return userPostCell
    }
    
}
