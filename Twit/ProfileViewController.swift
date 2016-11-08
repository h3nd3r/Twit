//
//  ProfileViewController.swift
//  Twit
//
//  Created by Sara Hender on 11/6/16.
//  Copyright © 2016 Sara Hender. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var tweets: Tweets!
    var userId: String!
    var user: User!
    
    @IBOutlet weak var backgroundProfileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var timelineView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        userId = User.current?.userId
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        print("looking up user with id \(userId)")
        
        TwitterClient.sharedInstance.user(user_id: userId, success: { (user: User) -> () in
            self.user = user
            
            self.usernameLabel.text = user.name
            self.handleLabel.text = "@" + (user.screenname)!
            
            self.tweetsLabel.text = user.tweets
            self.followersLabel.text = user.followers
            self.followingLabel.text = user.following
            
            if (user.profileBackgroundUrl != nil) {
                self.backgroundProfileImageView.setImageWith(user.profileBackgroundUrl!)
            } else {
                self.profileImageView.setImageWith(user.profileUrl!)
            }
            
            User.current = user
            
            print("Newly updated user info: \(user)")
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tweets = Tweets(type: .UserTimeline)
        tweets.userId = userId
            
        tweets.update(success: { (tweets: [Tweet]) -> () in
            self.tableView.reloadData()
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
        
        //usernameLabel.text = userId
        print("here in viewDidLoad with \(userId)")

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        userId = User.current?.userId
        
        print("looking up user with id \(userId)")
        
        TwitterClient.sharedInstance.user(user_id: userId, success: { (user: User) -> () in
            self.user = user
            
            self.usernameLabel.text = user.name
            self.handleLabel.text = "@" + (user.screenname)!
            self.profileImageView.setImageWith(user.profileUrl!)
            
            self.tweetsLabel.text = user.tweets
            self.followersLabel.text = user.followers
            self.followingLabel.text = user.following
            if (user.profileBackgroundUrl != nil) {
                self.backgroundProfileImageView.setImageWith(user.profileBackgroundUrl!)
                self.profileImageView.image = nil
            } else {
                self.profileImageView.setImageWith(user.profileUrl!)
                self.backgroundProfileImageView.image = nil
            }
            User.current = user
            
            print("Newly updated user info: \(user)")
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
        
        tweets = Tweets(type: .UserTimeline)
        tweets.userId = userId
        
        tweets.update(success: { (tweets: [Tweet]) -> () in
            self.tableView.reloadData()
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        print(#function)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        tweets.update(success: { (tweets: [Tweet]) -> () in
            print("Refreshing timeline: \(tweets.count)")
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TweetCell
        cell.tweet = tweets.tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tweets.tweets ?? []).count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets.tweets[(indexPath?.row)!]
            let tdvc = segue.destination as! TweetDetailViewController
            tdvc.tweet = tweet
        }
    }
}

