//
//  ViewController.swift
//  Fend App
//
//  Created by Katelyn Ge on 1/21/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import Firebase
import FirebaseDatabase
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mainView: UIView!
    
    var dict : [String : AnyObject]!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.center = view.center
        view.addSubview(loginButton)
        // Do any additional setup after loading the view, typically from a nib.
        //if the user is already logged in
        if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
        }
        self.ref = Database.database().reference(fromURL: "fend1-7e1bd.firebaseio.com")
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    self.ref.child("users").setValue(self.dict)
                }
            })
        }
    }
    
    
}

