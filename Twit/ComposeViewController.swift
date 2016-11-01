//
//  ComposeViewController.swift
//  Twit
//
//  Created by Sara Hender on 10/28/16.
//  Copyright © 2016 Sara Hender. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    var tweetReplyId: String?
    var tweetText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        userImageView.setImageWith((User.currentUser?.profileUrl)!)
        usernameLabel.text = User.currentUser?.name
        handleLabel.text = "@" + (User.currentUser?.screenname)!
        tweetTextView.text = tweetText
        tweetTextView.layer.cornerRadius = 10
    }

    override func viewDidAppear(_ animated: Bool) {
        tweetTextView.becomeFirstResponder()
    }
    
    @IBAction func cancelTweetAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sendTweetAction(_ sender: AnyObject) {
        TwitterClient.sharedInstance.tweet(message: tweetTextView.text, retweet_id: tweetReplyId, success: { () -> () in
            print("tweet successful")
            self.dismiss(animated: true, completion: nil)

            }, failure: { (error: Error) -> () in
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                print(error.localizedDescription)
                
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ComposeViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxtext: Int = 140
        return textView.text.characters.count + (text.characters.count - range.length) <= maxtext
    }
    
    func textViewDidChange(_ textView: UITextView) {
        charCountLabel.text = String(140 - textView.text.characters.count)
    }
}
