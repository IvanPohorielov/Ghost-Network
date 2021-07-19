//
//  PostViewController.swift
//  Ghost Network
//
//  Created by MacBook on 17.07.2021.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var postTextView: UITextView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        preventLargeTitleCollapsing()
        
        postButton.layer.cornerRadius = 10
        postTextView.layer.borderWidth = 0.5
        postTextView.layer.cornerRadius =  postTextView.frame.height / 60
        
    }
    
    @IBAction func postButtonDidPressed(_ sender: UIButton) {
    
        if validateTextView(textView: postTextView) == true {
            newPost(userToken: LoginManager.userToken!, subject: LoginManager.subject!, postContent: postTextView.text)
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func preventLargeTitleCollapsing() {
        let dummyView = UIView()
        view.addSubview(dummyView)
        view.sendSubviewToBack(dummyView)
    }
    
    func validateTextView (textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            SharedClass.sharedInstance.alert(view: self, title: "Error", message: "Please type something.")
            return false
        }
        return true
    }
    
    func newPost(userToken: String, subject: String, postContent: String) {
        
        let requestHeaders: [String:String] = ["Authorization" : "Bearer \(LoginManager.userToken!)",
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
                let str = String(decoding: data, as: UTF8.self)
                print(str)
            }
        }.resume()
    }
}
