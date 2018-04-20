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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
