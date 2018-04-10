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
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreLocation
import GooglePlaces
import UserNotifications

var fbId = ""

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet var mainView: UIView!
    
    var dict : [String : AnyObject]!
    var ref: DatabaseReference!
    var fbLoginSuccess = false
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create button
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        let newCenter = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height*(2/3))
        loginButton.center = newCenter
        //add it to view
        view.addSubview(loginButton)
        //if the user is already logged in
        
        if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
            print("load loginSegue")
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
        self.ref = Database.database().reference(fromURL: "fend1-7e1bd.firebaseio.com")
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        if let accessToken = FBSDKAccessToken.current(){
            print("appear loginSegue")
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    let num = self.dict["id"]
                    fbId = num as! String
                    self.ref.child("users").child(num as! String).child("userInfo").setValue(self.dict)
                }
            })
        }
 
    }
}

