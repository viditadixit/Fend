//
//  ProfileViewController.swift
//  Fend App
//
//  Created by Katelyn Ge on 1/31/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var fbLogin = true
    var ref: DatabaseReference!
    var dict : [String : AnyObject]!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var accountName: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    let list = ["My Reports", "Connect Device", "Past Notifications", "Purchase Fend", "About Fend", "Logout"]
    
    override func viewDidLoad(){
        //        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x:141, y: 20, width: 93, height: 44))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "fend logo.png")
        imageView.image = image;
        self.navigationItem.titleView = imageView
        
        self.ref = Database.database().reference(fromURL: "fend1-7e1bd.firebaseio.com")
        getFBUserData()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let reports = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reports")
            reports.textLabel?.text = list[0]
            reports.textLabel?.font = UIFont(name: "Nunito-Regular", size: 17)
            return reports;
        }else if(indexPath.row == 1){
            let device = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "device")
            device.textLabel?.text = list[1]
            device.textLabel?.font = UIFont(name: "Nunito-Regular", size: 17)
            return device;
        }else if(indexPath.row == 2){
            let notif = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "notif")
            notif.textLabel?.text = list[2]
            notif.textLabel?.font = UIFont(name: "Nunito-Regular", size: 17)
            return notif;
        }else if (indexPath.row == 3){
            let purchase = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "purchase")
            purchase.textLabel?.text = list[3]
            purchase.textLabel?.font = UIFont(name: "Nunito-Regular", size: 17)
            return purchase;
        }else {
            let about = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "about")
            about.textLabel?.text = list[4]
            about.textLabel?.font = UIFont(name: "Nunito-Regular", size: 17)
            return about;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let segueIdentifier: String
        switch indexPath.row {
        case 0: //For "one"
            segueIdentifier = "toReportList"
        case 1: //For "two"
            segueIdentifier = "toDevice"
        case 2: //For "three"
            segueIdentifier = "toNotifs"
        case 3: //For "four"
            segueIdentifier = "toPurchase"
        default: //For "five"
            segueIdentifier = "toAbout"
//        default: //For "six"
//            segueIdentifier = "toLogout"
        }
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }


    //logout
    @IBAction func buttonClicked(_ sender: Any) {
        FBSDKAccessToken.setCurrent(nil)
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    func getFBUserData(){
        //get picture
        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil).start(completionHandler: {(connection,result,error) -> Void in
            if (error == nil){
                guard let userInfo = result as? [String: Any] else { return } //handle the error
                print(userInfo)
                if let imageURL = (userInfo["data"] as? [String: Any])?["url"] as? String{
                    print("image URL is \(imageURL)")
                    if let url = URL(string : imageURL){
                        self.imageView.contentMode = .scaleAspectFit
                        self.imageView.layer.masksToBounds = false
                        self.imageView.layer.cornerRadius = self.imageView.frame.height/2
                        self.imageView.clipsToBounds = true
                        self.downloadImage(url: url)
                    }
                    print("image will continue downloading in background")
                }
            } else {
                print(error)
            }
        })
        //get other data
        FBSDKGraphRequest(graphPath: "me", parameters:["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                self.dict = result as! [String: AnyObject]
                let name = self.dict["name"]
                self.accountName.text = (name as! String)
                self.accountName.font = UIFont(name: "Nunito-Regular", size: 17)
            }
        })
    }
    
    func downloadImage(url: URL){
        print("Download Started")
        getDataFromURL(url: url){data, response, error in
            guard let data = data, error == nil else {return}
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async(){
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    func getDataFromURL(url: URL, completion: @escaping (Data?, URLResponse?, Error?) ->()){
        URLSession.shared.dataTask(with: url){ data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
  
}

