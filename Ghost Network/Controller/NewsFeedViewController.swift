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
    
    let postManager = NewsFeedManager()
    let deletePostManager = DeletePostManager()
    
    var posts: [PostModel] = []
    
    func fetchNewsFeed() {
        postManager.fetch(userId: LoginManager.subject!) { postsNewsFeed in
            self.posts = postsNewsFeed
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
        deletePostManager.delete(postId: posts[indexPath!.row].postId!, userToken: LoginManager.userToken!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            self.posts = []
            self.fetchNewsFeed()
        }
    }
}
