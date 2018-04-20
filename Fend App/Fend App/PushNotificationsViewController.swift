//
//  PushNotificationsViewController.swift
//  Fend App
//
//  Created by Vidita Dixit on 4/10/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import UIKit

class PushNotificationsViewController: UIViewController {
    
    @IBOutlet weak var notifications: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notifications.font = UIFont(name: "Nunito-Regular", size: 17)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
