//
//  TweetsViewController.swift
//  Twit
//
//  Created by Sara Hender on 10/26/16.
//  Copyright © 2016 Sara Hender. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets: Tweets!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        if tweets == nil {
            tweets = Tweets(type: .HomeTimeline)
        }
        
        tweets.update(success: { (tweets: [Tweet]) -> () in
            self.tableView.reloadData()
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        tableView.reloadData()
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        TwitterClient.sharedInstance.signout()
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        tweets.update(success: { (tweets: [Tweet]) -> () in
            //print("Refreshing timeline: \(tweets.count)")
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }
    
    @IBAction func tapUser(_ sender: UITapGestureRecognizer) {
        let cell = sender.view?.superview?.superview as! TweetCell
        print("\(cell.usernameLabel)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        User.current?.userId = cell.userId
        
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, tableDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TweetCell
        cell.tweet = tweets.tweets[indexPath.row]
        cell.delegate = self
        return cell
    }

    func tableDelegate(userId: String) {
        print("tapped \(userId)")
        User.current?.userId = userId
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profileViewController, animated: true)
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
