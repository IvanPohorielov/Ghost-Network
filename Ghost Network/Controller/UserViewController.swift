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
        super.viewWillAppear(true)
        fetchUserData()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        avatarImage.layer.masksToBounds = false
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width/2
        avatarImage.clipsToBounds = true
        
        posts = []
        fetchUserNewsFeed()
        
    }
    
    let postManager = UserNewsPostManager()
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
                        let dateOfBirthString = parceAge(dateOfBirth: dateOfBirth).0
                        let age = parceAge(dateOfBirth: dateOfBirth).1
                        
                        self.ageLabel.text =  "\(dateOfBirthString) (\(age) y.o.)"
                        
                    } else {
                        print("error")
                    }
                }
            } catch let jsonError {
                print("Fail to decode JSON", jsonError)
            }
        }.resume()
        
        func parceAge(dateOfBirth: String)  -> (String, Int){
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let formattedDate = formatter.date(from: dateOfBirth)
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "MMM d, yyyy"
            let dateOfBirth = formatter1.string(from: formattedDate!)
            let age = getAge(date: formattedDate!)
            
            func getAge(date: Date) -> Int {
                let calendar = Calendar.current
                let dateComponent = calendar.dateComponents([.year], from:
                                                                date, to: Date())
                
                return (dateComponent.year!)
            }
            
            return (dateOfBirth, age)
        }
    }
    
    // Getting posts
    var posts: [PostModel] = []
    
    func fetchUserNewsFeed() {
        
        postManager.fetch(userId: LoginManager.subject!) { postNewsFeed in
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
