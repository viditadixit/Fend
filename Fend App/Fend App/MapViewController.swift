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
import FirebaseDatabase

class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var googleMapsContainer: UIView!
    @IBOutlet weak var searchMaps: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mapSlider: UISlider!
    
    var googleMapsView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var camera: GMSCameraPosition!
    var locationManager = CLLocationManager()
    var locationRef: DatabaseReference!
    
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
        
        displayMarkers(time: 2)
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
    
    func displayMarkers(time: integer_t) {
        
        //clear all current markers
        self.googleMapsView.clear()
        
        //get coordinates from database
        locationRef = Database.database().reference().child("location")
        locationRef.observeSingleEvent(of: .value, with:  {(snapshot) in
            //print(snapshot.childrenCount)
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let restDict = rest.value as? [String:Any]
                let lat = restDict!["latitude"] as! Double
                let lon = restDict!["longitude"] as! Double
                let date = restDict!["date"] as? String
                
                if (self.isValidDate(date: (date?.toDate(dateFormat: "MM/dd/yyyy HH:mm"))!, time: time)) {
                    let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    let marker = GMSMarker(position: position)
                    marker.icon = UIImage(named: "pin")
                    marker.title = "Theft Occurred"
                    marker.snippet = date
                    marker.map = self.googleMapsView
                }
            }
        }) {(error) in print(error.localizedDescription)}
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        mapSlider.setValue(Float(lroundf(mapSlider.value)), animated: true)
        
        if (mapSlider.value == 0.0) {
            //googleMapsView.animate(toZoom: 0)
            self.displayMarkers(time: 0)
        } else if (mapSlider.value == 1.0) {
            //googleMapsView.animate(toZoom: 5)
            self.displayMarkers(time: 1)
        } else if (mapSlider.value == 2.0) {
            //googleMapsView.animate(toZoom: 10)
            self.displayMarkers(time:2)
        } else {
            //googleMapsView.animate(toZoom: 15)
            self.displayMarkers(time: 3)
        }
    }
    
    func isValidDate(date: Date, time: integer_t) -> Bool {
        var earlyDate : Date
        if (time == 0) {
            //1 day
            earlyDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!;
            if (date >= earlyDate) {
                return true
            }
            //print("Date is : \(earlyDate)")
        } else if (time == 1) {
            //1 week
            earlyDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!;
            if (date >= earlyDate) {
                return true
            }
            //print("Date is : \(earlyDate)")
        } else if (time == 2) {
            //1 month
            earlyDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!;
            if (date >= earlyDate) {
                return true
            }
            //print("Date is : \(earlyDate)")
        } else if (time == 3) {
            //year
            earlyDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!;
            if (date >= earlyDate) {
                return true
            }
            //print("Date is : \(earlyDate)")
        }
        
        return false
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

extension String
{
    func toDate( dateFormat format  : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        return dateFormatter.date(from: self)!
    }
}
