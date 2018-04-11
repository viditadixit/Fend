//
//  MyReportsViewController.swift
//  Fend App
//
//  Created by Katelyn Ge on 2/28/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Foundation

class MyReportsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var refReports: DatabaseReference!
    var dict : [String : AnyObject]!
    var ref: DatabaseReference!
    
    var testArray = ["why", "isn't", "this", "working"]

    @IBOutlet weak var tableView: UITableView!
    
    var reportTable = [reportStruct] ()
    struct reportStruct{
        let date: String!
        let description: String!
        let location: String!
        let theft: String!
    }
   
    var reportCount : UInt = 0

    
    
    //load table
    override func viewDidLoad(){
        super.viewDidLoad()
        viewReport()
        //print("viewReport")
        
    }
    
    //reload table
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated);
      //  viewReport()
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return testArray.count
        return self.reportTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print ("tableView load")
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reportInfo")
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportInfo", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0;
        let information = "Date: "+reportTable[indexPath.row].date+"\nDescription: "+reportTable[indexPath.row].description+"\nLocation: "+reportTable[indexPath.row].location+"\nTheft Type: "+reportTable[indexPath.row].theft
        cell.textLabel?.text = information
        cell.textLabel?.font = UIFont(name: "Nunito-Regular", size: 17)
        //cell.textLabel?.text = testArray[indexPath.row]
        return cell
    }
    

    
    func viewReport(){
        
        let reportsRef = Database.database().reference().child("users").child(fbId).child("reports")
       
        reportsRef.queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [AnyHashable:String]
            {
                let dateString = dictionary["date"]
                let descriptionString = dictionary["description"]
                let locationString = dictionary["location"]
                let theftString = dictionary["theft"]
                self.reportTable.insert(reportStruct(date: dateString, description: descriptionString, location: locationString, theft: theftString), at: 0)
                self.tableView.reloadData()
            }
        })
        
    }
    
    
}
