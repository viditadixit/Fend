//
//  LogoutViewController.swift
//  Fend App
//
//  Created by Katelyn Ge on 3/21/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin
import FBSDKCoreKit


class LogoutViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
//        loginButton.center = view.center
//        //add it to view
//        view.addSubview(loginButton)
//
//        if let accessToken = FBSDKAccessToken.current(){
//            //logged in
//        }
        FBSDKAccessToken.setCurrent(nil)
    }
}
