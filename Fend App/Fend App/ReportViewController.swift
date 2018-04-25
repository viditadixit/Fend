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

class ReportViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var theftPicker: UIPickerView!
    
    var refReports: DatabaseReference!
    var ref: DatabaseReference!
    var locationRef: DatabaseReference!
    var dict : [String : AnyObject]!
    var pickerData = ["Theft Attempted", "Theft Occurred"]
    
    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var Date: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var theftLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var latitude : CLLocationDegrees = 0.0
    var longitude : CLLocationDegrees = 0.0
    
    var theftLat : Double!
    var theftLong : Double!
    
    var theftType : String!
    
    @IBAction func buttonSubmit(_ sender: UIButton) {
        addReport()
        self.DescriptionTextField.text = ""
        self.LocationText.text = ""

        tabBarController?.selectedIndex = 0
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
        
        self.theftPicker.delegate = self
        self.theftPicker.dataSource = self
        self.DescriptionTextField.delegate = self;
        
        theftType = "Theft Attempted"
        
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.theftPicker.delegate = self
        self.theftPicker.dataSource = self
        self.DescriptionTextField.delegate = self;
    }
    
    func setUI() {
        dateLabel.font = UIFont(name: "Nunito-Regular", size: 17)
        locationLabel.font = UIFont(name: "Nunito-Regular", size: 17)
        descriptionLabel.font = UIFont(name: "Nunito-Regular", size: 17)
        theftLabel.font = UIFont(name: "Nunito-Regular", size: 17)
    }
    
    @IBAction func locationClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.DescriptionTextField {
            moveTextField(textField: DescriptionTextField, moveDistance: -200, up: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.DescriptionTextField {
            moveTextField(textField: DescriptionTextField, moveDistance: -200, up: false)
        }
    }
    
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
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
                      "description" : DescriptionTextField.text! as String,
                      "theft" : theftType as String]
        refReports.child(key).setValue(report)
        
        locationRef = Database.database().reference().child("location")
        let key1 = locationRef.childByAutoId().key
        
        let pin = ["latitude": Double(latitude),
                   "longitude": Double(longitude),
                   "date": convertedDate,
                   "theft": theftType as String] as [String : Any]
        
        locationRef.child(key1).setValue(pin)
        
        //TODO: store pin in database
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        theftType = pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        label.font = UIFont(name: "Nunito-Regular", size: 17)
        label.text = pickerData[row]
        label.textAlignment = NSTextAlignment.center
        return label
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

