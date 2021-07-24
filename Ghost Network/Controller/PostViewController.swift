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
    
    var newPostManager = NewPostManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        preventLargeTitleCollapsing()
        
        postButton.layer.cornerRadius = 10
        postTextView.layer.borderWidth = 0.5
        postTextView.layer.cornerRadius =  postTextView.frame.height / 60
        
    }
    
    @IBAction func postButtonDidPressed(_ sender: UIButton) {
    
        if validateTextView(textView: postTextView) == true {
        newPostManager.newPost(userToken: LoginManager.userToken!, postContent: postTextView.text)
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
}
