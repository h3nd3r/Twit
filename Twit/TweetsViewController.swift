//
//  TweetsViewController.swift
//  Twit
//
//  Created by Sara Hender on 10/26/16.
//  Copyright © 2016 Sara Hender. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets: [Tweet]!
    var isMoreDataLoading = false
    
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
        
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            print("Number of tweets in timeline: \(tweets.count)")
            for tweet in tweets {
                print(tweet.text ?? "")
                }
                self.tableView.reloadData()
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        
        // Do any additional setup after loading the view.
    }

    @IBAction func logout(_ sender: AnyObject) {
        TwitterClient.sharedInstance.signout()
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
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
}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tweets ?? []).count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            let tdvc = segue.destination as! TweetDetailViewController
            tdvc.tweet = tweet
        }
    }
}
