//
//  Tweet.swift
//  Twit
//
//  Created by Sara Hender on 10/26/16.
//  Copyright © 2016 Sara Hender. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: String?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var user: String?
    var userImageUrlString: String?
    var userImageUrl: URL?
    var tweedId: String?
    var screenName: String?
    var userId: String?
    
    init(dictionary: NSDictionary) {
        //print(dictionary)
        screenName = (dictionary["user"] as! NSDictionary)["screen_name"] as? String
        userId = (dictionary["user"] as! NSDictionary)["id_str"] as? String
        tweedId = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        user = (dictionary["user"] as! NSDictionary)["name"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        userImageUrlString = (dictionary["user"] as! NSDictionary)["profile_image_url_https"] as? String
        if let userImageUrlString = userImageUrlString {
            userImageUrl = URL(string: userImageUrlString)
        }
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            /*
            let dateString = "Thu, 22 Oct 2015 07:45:17 +0000"
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
            //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            let dateObj = dateFormatter.dateFromString(dateString)
 
            dateFormatter.dateFormat = "MM-dd-yyyy"
            print("Dateobj: \(dateFormatter.stringFromDate(dateObj!))")
            */
            
            let formatter = DateFormatter()
            formatter.dateFormat =  "EEE MMM d HH:mm:ss Z y"
            let tmp = formatter.date(from: timestampString)
            timestamp = formatter.string(from: tmp!)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets:[Tweet] = []
        
        //print(dictionaries)
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
}
