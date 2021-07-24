//
//  PostCell.swift
//  Ghost Network
//
//  Created by MacBook on 13.07.2021.
//

import UIKit

protocol PostCellDelegate: AnyObject {
    func didTap(_ cell: PostCell)
}

class PostCell: UITableViewCell {
    
    @IBOutlet weak var postBody: UIView!
    @IBOutlet weak var avatarImage: RoundedImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: PostCellDelegate?
    var post: PostModel?
   
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postBody.layer.cornerRadius = postBody.frame.size.height / 15
        likeButton.layer.cornerRadius = 15
        commentButton.layer.cornerRadius = 15
       
        contentLabel.text = post?.postContent
        fullNameLabel.text = post?.authorFullName
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        buttonAnimation(sender: sender)
        delegate?.didTap(self)
    }
    
    func buttonAnimation(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
                       },
                       completion: { Void in()  }
        )
    }
}
