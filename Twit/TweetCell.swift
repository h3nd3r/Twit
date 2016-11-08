//
//  TweetCell.swift
//  Twit
//
//  Created by Sara Hender on 10/28/16.
//  Copyright © 2016 Sara Hender. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    var userId: String!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!

    var delegate: tableDelegate?
    
    var tweet: Tweet! {
        didSet {
            // print("hello \(tweet.userImageUrlString)")
            usernameLabel.text = tweet.user
            timestampLabel.text = tweet.timestamp
            tweetLabel.text = tweet.text
            userId = tweet.userId
            if tweet.userImageUrl != nil {
                userImageView.setImageWith(tweet.userImageUrl!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(tapTouch)/*Selector("tapTouch:")*/)
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }

    func tapTouch(sender: UITapGestureRecognizer) {
        delegate?.tableDelegate(userId: userId)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

protocol tableDelegate {
    func tableDelegate(userId: String)
}
