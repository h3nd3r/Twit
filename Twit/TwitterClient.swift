//
//  TwitterClient.swift
//  Twit
//
//  Created by Sara Hender on 10/26/16.
//  Copyright © 2016 Sara Hender. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "IHeVRsv0giLNYkc4hBQYd8JKB", consumerSecret: "a1VWtMq4qvaXiMx6zWKLtkf5uuwWndj9G1V2oqQexWzHma1mkU")!

    var signinSuccess: (() -> ())?
    var signinFailure: ((NSError) -> ())?

    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:
            BDBOAuth1Credential?) -> Void in
            
            self.signinSuccess?()
            
        }) { (error: Error?) -> Void in
            print("error: \(error)")
            self.signinFailure?(error as! NSError)
        }
    }
    
    func signin(success: @escaping ()->(), failure: @escaping (NSError)->()) {
        signinSuccess = success
        signinFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token",
                                                       method: "GET",
                                                       callbackURL: URL(string: "twit://oauth"),
                                                       scope: nil,
                                                       success: { (requestToken:
                                                        BDBOAuth1Credential?)->Void in
                                                        //print("I got a token! oauth_token=\(requestToken!.token!)")
                                                        
                                                        let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
                                                        UIApplication.shared.openURL(url!)
                                                        
        }) { (error: Error?) -> Void in
            print("error: \(error)")
            //self.signinFailure(error)
        }
        
        
        
        
    }
    
    func currentAccount() {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            

            
            print("account: \(response)")
            let userDictionary = response as? NSDictionary
            
            let user = User(dictionary: userDictionary!)
            
            //print("user: \(user)")
            print("name: \(user.name)")
            print("screenname: \(user.screenname)")
            print("profile url: \(user.profileUrl)")
            print("description: \(user.description)")
            
            }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) ->(), failure: (NSError) ->()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
                   success: { (task: URLSessionDataTask, response: Any?) -> Void in
                    let dictionaries = response as! [NSDictionary]
                    let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                    
                    success(tweets)
                    
                    //for tweet in tweets {
                    //    print("\(tweet.text)")
                    //}
            }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in })
    }
    
}
