//
//  Tweets.swift
//  Twit
//
//  Created by Sara Hender on 11/7/16.
//  Copyright © 2016 Sara Hender. All rights reserved.
//

import UIKit

enum Type {
    case HomeTimeline
    case UserTimeline
    case Mentions
}

class Tweets: NSObject {

    var tweets: [Tweet]!
    var type: Type
    var userId: String!
    
    init(type: Type) {
        self.type = type
    }

    func update(success: @escaping ([Tweet]) ->(), failure: @escaping (NSError) ->()) {
        switch type
        {
        case .HomeTimeline:
                TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    success(tweets)
                    /*
                    print("Number of tweets in timeline: \(tweets.count)")
                    for tweet in tweets {
                        print(tweet.text ?? "")
                    }
                    self.tableView.reloadData()*/
                }, failure: { (error: Error) -> () in
                    failure(error as NSError)
                    //print(error.localizedDescription)
                })
        case .UserTimeline:
            TwitterClient.sharedInstance.userTimeline(user_id: userId!, success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                success(tweets)
                /* self.tweets = tweets
                print("Number of tweets in timeline: \(tweets.count)")
                for tweet in tweets {
                    print(tweet.text ?? "")
                }
                self.tableView.reloadData()*/
            }, failure: { (error: Error) -> () in
                failure(error as NSError)
                //print(error.localizedDescription)
            })
        case .Mentions:
            TwitterClient.sharedInstance.mentions(success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                success(tweets)
                /*self.tweets = tweets
                print("Number of tweets in timeline: \(tweets.count)")
                for tweet in tweets {
                    print(tweet.text ?? "")
                }
                self.tableView.reloadData()*/
            }, failure: { (error: Error) -> () in
                failure(error as NSError)
                //print(error.localizedDescription)
            })
        }
    }
}
