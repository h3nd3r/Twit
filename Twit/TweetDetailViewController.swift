//
//  TweetDetailViewController.swift
//  Twit
//
//  Created by Sara Hender on 10/28/16.
//  Copyright © 2016 Sara Hender. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    var replyButton: UIBarButtonItem?
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tweet"

        let replyButton = UIBarButtonItem(title: "Reply", style: .plain, target: self, action: #selector(replyButtonAction))
        self.navigationItem.rightBarButtonItem  = replyButton
        
        userImageView.setImageWith((tweet?.userImageUrl!)!)
        usernameLabel.text = tweet?.user
        timestampLabel.text = tweet?.timestamp
        tweetLabel.text = tweet?.text
        retweetsCountLabel.text = String(describing: tweet?.retweetCount ?? 0)
        favoritesCountLabel.text = String(describing: tweet?.favoriteCount ?? 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func replyButtonAction() {
        print("nothing hooked up yet")
        reply()
    }
    
    @IBAction func replyAction(_ sender: AnyObject) {
        print(#function)
        
        reply()
    }
    
    func reply() {
        print(tweet ?? "")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cvc = storyboard.instantiateViewController(withIdentifier: "ComposeViewController") as! ComposeViewController
        cvc.tweetReplyId = tweet?.tweedId
        cvc.tweetText = "@" + (tweet?.screenName)! + " "
        let nc = UINavigationController(rootViewController: cvc)
        self.present(nc, animated: true, completion: nil)
    }
    
    @IBAction func retweet(_ sender: AnyObject) {
        print(#function)
        // need to pass in tweet?.tweedId
        TwitterClient.sharedInstance.retweet(retweet_id: (tweet?.tweedId)!, success: { () -> () in
            print("retweet successful")
            self.tweet?.retweetCount += 1
            self.retweetsCountLabel.text = String(describing: (self.tweet?.retweetCount)!)
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
    
    @IBAction func favorites(_ sender: AnyObject) {
        print(#function)
        TwitterClient.sharedInstance.favorite(favorite_id: (tweet?.tweedId)!, success: { () -> () in
            print("favorite successful")
            self.tweet?.favoriteCount += 1
            self.favoritesCountLabel.text = String(describing: (self.tweet?.favoriteCount)!)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
