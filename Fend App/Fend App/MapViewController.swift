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
import CoreLocation

class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var googleMapsContainer: UIView!
    @IBOutlet weak var searchMaps: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mapSlider: UISlider!
    
    var googleMapsView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var camera: GMSCameraPosition!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        
        searchMaps.delegate = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        self.googleMapsView = GMSMapView(frame: self.googleMapsContainer.frame)
        googleMapsView.settings.myLocationButton = true
        googleMapsView.isMyLocationEnabled = true
        searchMaps.layer.borderWidth = 0.5
        
        self.view.addSubview(googleMapsView)
        googleMapsView.addSubview(searchMaps)
        googleMapsView.addSubview(searchButton)
        googleMapsView.addSubview(mapSlider)
        
        displayMarkers()
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
        
        googleMapsView.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func displayMarkers() {
        //get coordinates from database
        
        let latitude = [27.02834, -27.97589, 41.30578, -8.24380, -11.20098, 0.49786, -18.26830, 54.23442, 31.49618, 65.61194]
        let longitude = [109.62281, 120.36426, 93.15085, -54.55858, -59.45719, 109.14648, -48.01558, 98.74914, 114.86978, -109.32365]
        
        for i in 1...latitude.count {
            let lat = latitude[i-1]
            let lon = longitude[i-1]
            let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "pin")
            marker.title = "Theft Occurred"
            let snippet = String(lat) + " " + String(lon)
            marker.snippet = snippet
            marker.map = googleMapsView
        }
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        mapSlider.setValue(Float(lroundf(mapSlider.value)), animated: true)
        
        if (mapSlider.value == 0.0) {
            googleMapsView.animate(toZoom: 0)
        } else if (mapSlider.value == 1.0) {
            googleMapsView.animate(toZoom: 5)
        } else if (mapSlider.value == 2.0) {
            googleMapsView.animate(toZoom: 10)
        } else {
            googleMapsView.animate(toZoom: 15)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.searchMaps.text = place.name
        googleMapsView.moveCamera(GMSCameraUpdate.fit(place.viewport!))
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.searchMaps.text = ""
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

