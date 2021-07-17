//
//  PostCell.swift
//  Ghost Network
//
//  Created by MacBook on 13.07.2021.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postBody: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postBody.layer.cornerRadius = postBody.frame.size.height / 15
        likeButton.layer.cornerRadius = 15
        commentButton.layer.cornerRadius = 15
        avatarImage.layer.masksToBounds = false
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width/2
        avatarImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
