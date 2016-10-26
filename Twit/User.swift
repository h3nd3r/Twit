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
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        tagline = dictionary["description"] as? String
        
        
    }
}
