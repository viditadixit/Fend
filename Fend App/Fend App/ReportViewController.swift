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
import GooglePlaces

class ReportViewController: UIViewController, UITextFieldDelegate {
    
    var refReports: DatabaseReference!
    var ref: DatabaseReference!
    var locationRef: DatabaseReference!
    var dict : [String : AnyObject]!
    
    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var Date: UIDatePicker!
    
    var latitude : CLLocationDegrees = 0.0
    var longitude : CLLocationDegrees = 0.0
    
    var theftLat : Double!
    var theftLong : Double!
    
    @IBAction func buttonSubmit(_ sender: UIButton) {
        addReport()
        self.DescriptionTextField.text = ""
        self.LocationText.text = ""
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.DescriptionTextField.delegate = self;
        
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
    }
    
    @IBAction func locationClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
        
        locationRef = Database.database().reference().child("location")
        let key1 = locationRef.childByAutoId().key
        
        let pin = ["latitude": Double(latitude),
                   "longitude": Double(longitude),
                   "date": convertedDate] as [String : Any]
        
        locationRef.child(key1).setValue(pin)
        
        //TODO: store pin in database
    }
}

extension ReportViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        LocationText.text = place.formattedAddress
        self.latitude = place.coordinate.latitude
        self.longitude = place.coordinate.longitude
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        //LocationText.text = " "
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

