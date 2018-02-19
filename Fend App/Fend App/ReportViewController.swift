//
//  ReportViewController.swift
//  Fend App
//
//  Created by Kirtana Moorthy on 1/31/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import UIKit
import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ReportViewController: UIViewController {
    
    var refReports: DatabaseReference!
    var ref: DatabaseReference!
    var dict : [String : AnyObject]!

    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var Date: UIDatePicker!
    
    
    @IBAction func buttonSubmit(_ sender: UIButton) {
        addReport()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print (result)
                    print (self.dict)
                    let val = self.dict["id"] as! String
                    print (val)
                    self.refReports = Database.database().reference().child("users").child(val).child("reports")
                }
            })
        }
        
    //  refReports = Database.database().reference().child("reports");

    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        
    }
    
    func changeDateToString(sender: UIDatePicker) -> String {
        print("print \(sender.date)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let somedateString  = dateFormatter.string(from: sender.date)
        
        print(somedateString)
        return somedateString
    }
    
    func addReport(){
        let key = refReports.childByAutoId().key
        let convertedDate = changeDateToString(sender: Date)
        
        let report = ["id": key,
                      "date": convertedDate,
                      "location": LocationText.text! as String,
                      "description" : DescriptionTextField.text! as String ]
        refReports.child(key).setValue(report)
    }
    
    
    
}
