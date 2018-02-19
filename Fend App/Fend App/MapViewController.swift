//
//  MapViewController.swift
//  Fend App
//
//  Created by Vidita Dixit on 1/30/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var googleMapsContainer: UIView!
    @IBOutlet weak var searchMaps: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    
    var googleMapsView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var position: CLLocationCoordinate2D!
    var marker: GMSMarker!
    var camera: GMSCameraPosition!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        searchMaps.delegate = self
        
        self.googleMapsView = GMSMapView(frame: self.googleMapsContainer.frame)
        googleMapsView.settings.myLocationButton = true
        googleMapsView.isMyLocationEnabled = true
        searchMaps.layer.borderWidth = 0.5
        
        //let camera = GMSCameraPosition.camera(withTarget: googleMapsView.myLocation!.coordinate, zoom: 15.0)
        //self.googleMapsView.camera = camera
        
        position = CLLocationCoordinate2D()
        marker = GMSMarker()
            
        self.view.addSubview(googleMapsView)
        googleMapsView.addSubview(searchMaps)
        googleMapsView.addSubview(searchButton)
        
        if (googleMapsView.isMyLocationEnabled) {
            let myLocation = googleMapsView.myLocation
            print(myLocation)
            if (myLocation != nil) {
                print("yes")
                googleMapsView.animate(toLocation: (myLocation?.coordinate)!)
            }
        }
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        /*print("Place name: \(place.name)")
         print("Place address: \(place.formattedAddress)")
         print("Place attributions: \(place.attributions)")*/
        //position = place.coordinate
        print("Place address: \(place.formattedAddress)")
        print("Place coordinate: \(place.coordinate)")
        
        //marker.map = nil
        position = place.coordinate
        marker.position = position
        marker.map = googleMapsView
        marker.tracksViewChanges = true
        googleMapsView.animate(toLocation: position)
        googleMapsView.animate(toZoom: 15)
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
