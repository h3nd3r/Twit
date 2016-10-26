//
//  SignInViewController.swift
//  Twit
//
//  Created by Sara Hender on 10/26/16.
//  Copyright © 2016 Sara Hender. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//'(BDBOAuth1Credential!) -> Void' to expected argument type '((BDBOAuth1Credential?) -> Void)!'}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSignIn(_ sender: AnyObject) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "IHeVRsv0giLNYkc4hBQYd8JKB", consumerSecret: "a1VWtMq4qvaXiMx6zWKLtkf5uuwWndj9G1V2oqQexWzHma1mkU")
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token",
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
                                        }
    }
}
