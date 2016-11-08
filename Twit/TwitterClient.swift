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

    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "hszFHlCZ4n8mXjRMkEd9OstLU", consumerSecret: "URdUxwsAyFfGDXZXsotxAiZRYi5gKCMb82rA5vV4S3Nyide65l")!

    var signinSuccess: (() -> ())?
    var signinFailure: ((NSError) -> ())?
    
    func signin(success: @escaping ()->(), failure: @escaping (NSError)->()) {
        print(#function)        
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

    func handleOpenUrl(url: URL) {
        print(#function)
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:
            BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: { (user: SignInUser) -> () in
                    SignInUser.currentUser = user
                    self.signinSuccess?()
                }, failure: { (error: NSError)->() in
                    self.signinFailure?(error)
            })
        }) { (error: Error?) -> Void in
            print("error: \(error)")
            self.signinFailure?(error as! NSError)
        }
    }
    
    func currentAccount(success: @escaping (SignInUser)->(), failure: @escaping (NSError) -> ()) {
        print(#function)
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
                //print("account: \(response)")
                let userDictionary = response as? NSDictionary
                let user = SignInUser(dictionary: userDictionary!)
                //print("created user")
                success(user)
                //print("ran success closure")
            
            }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                failure(error as NSError)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) ->(), failure: @escaping (NSError) ->()) {
        //print("trying to fetch my timeline")

        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
                   success: { (task: URLSessionDataTask, response: Any?) -> Void in
                    let dictionaries = response as! [NSDictionary]
                    let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                                 
                    success(tweets)
                    
            }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                failure(error as NSError)
        })
    }

    func mentions(success: @escaping ([Tweet]) ->(), failure: @escaping (NSError) ->()) {
        //print("trying to fetch my mentions")
        
        get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                success(tweets)
                
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error as NSError)
        })
    }

    func userTimeline(user_id: String, success: @escaping ([Tweet]) ->(), failure: @escaping (NSError) ->()) {
        //print("trying to fetch my mentions")
        
        let parameters: [String: AnyObject] = ["user_id" : user_id as AnyObject]
        
        get("1.1/statuses/user_timeline.json", parameters: parameters, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                success(tweets)
                
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error as NSError)
        })
    }
    
    func tweet(message: String, retweet_id: String?, success: @escaping () ->(), failure: @escaping (NSError) ->()) {
        //print("trying to send a tweet")
        // TODO: set parameters
        var parameters: [String: AnyObject] = ["status" : message as AnyObject]
        
        if (retweet_id != nil) {
            parameters["in_reply_to_status_id"] = retweet_id as AnyObject?
        }
        
        post("1.1/statuses/update.json", parameters: parameters, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
              //print("tweeted successfully")
              success()
                
            }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                failure(error as NSError)
        })
    }
    func favorite(favorite_id: String, success: @escaping () ->(), failure: @escaping (NSError) ->()) {
        print("trying to favorite")
        let parameters: [String: AnyObject] = ["id" : favorite_id as AnyObject]
        post("/1.1/favorites/create.json", parameters: parameters, progress: nil,
                       success: { (task: URLSessionDataTask, response: Any?) -> Void in
                        print("favorited successfully")
                        success()
                        
            }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                failure(error as NSError)
        })
    }
    
    func retweet(retweet_id: String, success: @escaping () ->(), failure: @escaping (NSError) ->()) {
        //print("trying to send a retweet with message id \(retweet_id)")
        post("1.1/statuses/retweet/" + retweet_id + ".json", parameters: nil, progress: nil,
                       success: { (task: URLSessionDataTask, response: Any?) -> Void in
                        //print("retweeted successfully")
                        success()
                        
            }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                failure(error as NSError)
        })
    }
    
    func user(user_id: String, success: @escaping (User) ->(), failure: @escaping (NSError) ->()) {
        //print("trying fetch info about user id \(user_id)")
        
        let parameters: [String: AnyObject] = ["user_id" : user_id as AnyObject]
        //let parameters: [String: String] = ["screen_name" : screen_name]
        
        //print(parameters)
        get("1.1/users/show.json", parameters: parameters, progress: nil,
             success: { (task: URLSessionDataTask, response: Any?) -> Void in
                //print("fetched user \(user_id)")
                let dictionaries = response as! NSDictionary
                //print(dictionaries)
                let user = User(dictionary: dictionaries)
                success(user)
                
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error as NSError)
        })
    }
    
    func signout(){
        SignInUser.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SignInUser.userDidLogoutNotification), object: nil)
    }
}
