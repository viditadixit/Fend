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
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
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
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ReportViewController = segue.destination as? ReportViewController {
            ReportViewController.dict = dict
            print (ReportViewController.dict)
        }
    }
 */
    
    //function is fetching the user data
    func getFBUserData(){
        /*
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
            guard let uid = user?.uid else {
                return
            }
            let usersReference = self.ref.child("users").child(uid)
            if((FBSDKAccessToken.current()) != nil){
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let values: [String:AnyObject] = result as! [String : AnyObject]
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            // if there's an error in saving to our firebase database
                            if err != nil {
                                print(err)
                                return
                            }
                            // no error, so it means we've saved the user into our firebase database successfully
                            print("Save the user successfully into Firebase database")
                        })
                    }
                })
            }
            
        }
       
        
        // create a child reference - uid will let us wrap each users data in a unique user id for later reference
        
     */ if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    let num = self.dict["id"]
                    self.ref.child("users").child(num as! String).child("userInfo").setValue(self.dict)
                }
            })
        }
 
    }
    
    
  
    
    
}

