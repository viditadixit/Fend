//
//  PushNotificationsViewController.swift
//  Fend App
//
//  Created by Vidita Dixit on 4/10/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Foundation

class PushNotificationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refTriggers: DatabaseReference!
    var dict : [String: AnyObject]!
    var ref: DatabaseReference!
    
    var triggerTable = [triggerStruct]()
    struct triggerStruct{
        let date: String!
        let address: String!
    }
    
    var triggerCount : UInt = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.triggerTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "triggerInfo", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0;
        let information = "Date: "+triggerTable[indexPath.row].date+"\nAddress: "+triggerTable[indexPath.row].address
        cell.textLabel?.text = information
        print(information)
        cell.textLabel?.font = UIFont(name: "Nunito-Regular", size: 17)
        return cell
    
    }
    
    func loadTable(){
        let triggerRef = Database.database().reference().child("users").child(fbId).child("triggers")
        triggerRef.queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [AnyHashable:String]
            {
                let dateString = dictionary["date"]
                let addressString = dictionary["address"]
                self.triggerTable.insert(triggerStruct(date: dateString, address: addressString), at: 0)
                self.tableView.reloadData()
            }
        })
    }

}
