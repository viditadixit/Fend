//
//  PurchaseFendViewController.swift
//  Fend App
//
//  Created by Vidita Dixit on 4/11/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import UIKit
import GooglePlaces

class PurchaseFendViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var quantity: UITextView!
    @IBOutlet weak var name: UITextView!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var phone: UITextView!
    @IBOutlet weak var email: UITextView!
    
    @IBOutlet weak var quantityPicker: UIPickerView!
    
    let quantityDataSource = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        quantityPicker.delegate = self
        quantityPicker.dataSource = self
        
        nameField.delegate = self
        phoneField.delegate = self
        emailField.delegate = self
        
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        quantity.font = UIFont(name: "Nunito-Regular", size: 17)
        name.font = UIFont(name: "Nunito-Regular", size: 17)
        address.font = UIFont(name: "Nunito-Regular", size: 17)
        phone.font = UIFont(name: "Nunito-Regular", size: 17)
        email.font = UIFont(name: "Nunito-Regular", size: 17)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false;
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return quantityDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quantityDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        label.font = UIFont(name: "Nunito-Regular", size: 17)
        label.text = quantityDataSource[row]
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    @IBAction func addressClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func paymentButton(_ sender: Any) {
        let alert = UIAlertController(title: "Product Unavailable", message: "Sorry, this product is currently unavailable. Thank you for your interest!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}

extension PurchaseFendViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        addressField.text = place.formattedAddress
        
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
