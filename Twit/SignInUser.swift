//
//  SignInUser.swift
//  Twit
//
//  Created by Sara Hender on 11/6/16.
//  Copyright © 2016 Sara Hender. All rights reserved.
//

import UIKit

class SignInUser: User {
    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: SignInUser?
    class var currentUser: SignInUser? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: [])
                    _currentUser = SignInUser(dictionary: dictionary as! NSDictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            print("trying to set user")
            
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
    func details(dictionaries: NSDictionary) {
        
    }
}
