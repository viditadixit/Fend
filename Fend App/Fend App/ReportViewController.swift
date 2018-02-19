//
//  ReportViewController.swift
//  Fend App
//
//  Created by Kirtana Moorthy on 1/31/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import UIKit
import GooglePlaces

class ReportViewController: UIViewController {
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var Date: UIDatePicker!
    
    @IBAction func locationClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //LocationText.text = ""
        //DescriptionTextField.text = ""
    
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
}

extension ReportViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        /*print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")*/
        LocationText.text = place.formattedAddress
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
