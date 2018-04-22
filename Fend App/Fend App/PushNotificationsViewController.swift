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

class PushNotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refTriggers: DatabaseReference!
    var dict : [String: AnyObject]!
    var ref: DatabaseReference!
    
    var triggerTable = [triggerStruct]()
    struct triggerStruct{
        let date: String!
        let address: String!
        let id: String!
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.triggerTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "triggerInfo", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0;
        let information = "Date: "+triggerTable[indexPath.row].date+"\nAddress: "+triggerTable[indexPath.row].address
        cell.textLabel?.text = information
        //print(information)
        cell.textLabel?.font = UIFont(name: "Nunito-Regular", size: 17)
        return cell

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let thisId = self.triggerTable[indexPath.row].id as! String
            self.refTriggers.child(thisId).removeValue()
            
            self.triggerTable.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
    
        }
        
        return [delete]
    }
    
    func loadTable(){
        let triggerRef = Database.database().reference().child("users").child(fbId).child("triggers")
        refTriggers = triggerRef
        triggerRef.queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [AnyHashable:String]
            {
                let dateString = dictionary["date"]
                let addressString = dictionary["address"]
                let idString = dictionary["id"]
                self.triggerTable.insert(triggerStruct(date: dateString, address: addressString, id: idString), at: 0)
                self.tableView.reloadData()
            }
        })
    }

}
