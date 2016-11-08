//
//  User.swift
//  Twit
//
//  Created by Sara Hender on 10/26/16.
//  Copyright © 2016 Sara Hender. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    var dictionary: NSDictionary?
    var userId: String?
    var tweets: String = "0"
    var followers: String = "0"
    var following: String = "0"
    var profileBackgroundUrl: URL?
    
//    "profile_background_image_url_https": "https://si0.twimg.com/images/themes/theme1/bg.png",
//    "profile_background_color": "C0DEED",
    
    static var _current: User?
    class var current: User? {
        get {
            if _current == nil {
                _current = SignInUser._currentUser
            }
            return _current
        }
        set(user) {
            print("trying to set user")
            
            _current = user
        }
    }
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        self.name = dictionary["name"] as? String
        self.followers = String(describing: dictionary["followers_count"] as! Int)
        self.following = String(describing: dictionary["friends_count"] as! Int)
        self.tweets = String(describing: dictionary["statuses_count"] as! Int)
        
        self.screenname = dictionary["screen_name"] as? String
        self.name = dictionary["name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            self.profileUrl = URL(string: profileUrlString)
        }
        
        let profileBackgroundUrlString = dictionary["profile_background_image_url_https"] as? String
        if let profileBackgroundUrlString = profileBackgroundUrlString {
            self.profileBackgroundUrl = URL(string: profileBackgroundUrlString)
        }
        
        self.tagline = dictionary["description"] as? String
        self.userId = dictionary["id_str"] as? String
    }
}
