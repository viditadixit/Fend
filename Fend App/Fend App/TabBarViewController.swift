//
//  TabBarViewController.swift
//  Fend App
//
//  Created by Katelyn Ge on 3/21/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import UIKit
import Foundation
import FBSDKCoreKit
import FirebaseDatabase


class TabBarViewController: UITabBarController{
    
    var dict : [String : AnyObject]!
    var ref: DatabaseReference!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print("TAB BAR CONTROLLER LOAD")
        if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
        } else {
            print("load loginSegue2")
            performSegue(withIdentifier: "loginSegue2", sender: self)
        }
        print(fbId)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedStringKey.font: UIFont(name:"Nunito-Regular", size:11)!],
            for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("TAB BAR CONTROLLER APPEAR")
        if let accessToken = FBSDKAccessToken.current(){
           getFBUserData()
        } else {
            print("appear loginSegue2")
            performSegue(withIdentifier: "loginSegue2", sender: self)
        }
        print(fbId)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedStringKey.font: UIFont(name:"Nunito-Regular", size:11)!],
            for: .normal)
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    //print(result!)
                    //print(self.dict)
                    let num = self.dict["id"]
                    fbId = num as! String
                }
            })
        }
        
    }

}
