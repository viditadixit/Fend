//
//  TabBarViewController.swift
//  Fend App
//
//  Created by Katelyn Ge on 3/21/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FirebaseDatabase


class TabBarViewController: UITabBarController{
    
    var dict : [String : AnyObject]!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print("TAB BAR CONTROLLER LOAD")
        if let accessToken = FBSDKAccessToken.current(){
           // getFBUserData()
        } else {
            print("load loginSegue2")
            performSegue(withIdentifier: "loginSegue2", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("TAB BAR CONTROLLER APPEAR")
        if let accessToken = FBSDKAccessToken.current(){
           // getFBUserData()
        } else {
            print("appear loginSegue2")
            performSegue(withIdentifier: "loginSegue2", sender: self)
        }
    }

}
