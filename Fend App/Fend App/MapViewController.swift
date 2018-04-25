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
import UserNotifications

class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var googleMapsContainer: UIView!
    @IBOutlet weak var searchMaps: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var day: UIButton!
    @IBOutlet weak var week: UIButton!
    @IBOutlet weak var month: UIButton!
    @IBOutlet weak var year: UIButton!

    var googleMapsView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var camera: GMSCameraPosition!
    var locationManager = CLLocationManager()
    var locationRef: DatabaseReference!
    
    var from = 1;
    var to = 1;
    
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
        
        googleMapsView.addSubview(day)
        googleMapsView.addSubview(week)
        googleMapsView.addSubview(month)
        googleMapsView.addSubview(year)
        
        setUI()

        self.displayMarkers(time: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.displayMarkers(time: 1)
    }
    
    func setUI() {
        day.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        day.titleLabel?.font = UIFont(name: "Nunito-Regular", size: 16)
        week.backgroundColor = UIColor(red: 102/255, green: 196/255, blue: 176/255, alpha: 1);
        week.titleLabel?.font = UIFont(name: "Nunito-Regular", size: 16)
        month.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        month.titleLabel?.font = UIFont(name: "Nunito-Regular", size: 16)
        year.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        year.titleLabel?.font = UIFont(name: "Nunito-Regular", size: 16)
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
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let restDict = rest.value as? [String:Any]
                let lat = restDict!["latitude"] as! Double
                let lon = restDict!["longitude"] as! Double
                let date = restDict!["date"] as? String
                let theft = restDict!["theft"] as? String
                print(theft)
                
                if (self.isValidDate(date: (date?.toDate(dateFormat: "MM/dd/yyyy HH:mm"))!, time: time)) {
                    let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    let marker = GMSMarker(position: position)
                    marker.icon = UIImage(named: "pin")
                    marker.title = theft
                    marker.snippet = date
                    marker.map = self.googleMapsView
                }
            }
        }) {(error) in print(error.localizedDescription)}
    }
    
    @IBAction func day(_ sender: Any) {
        day.backgroundColor = UIColor(red: 102/255, green: 196/255, blue: 176/255, alpha: 1);
        week.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        month.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        year.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        self.displayMarkers(time: 0)
    }
    
    @IBAction func week(_ sender: Any) {
        day.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        week.backgroundColor = UIColor(red: 102/255, green: 196/255, blue: 176/255, alpha: 1);
        month.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        year.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        self.displayMarkers(time: 1)
    }
    
    @IBAction func month(_ sender: Any) {
        day.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        week.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        month.backgroundColor = UIColor(red: 102/255, green: 196/255, blue: 176/255, alpha: 1);
        year.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        self.displayMarkers(time:2)
    }
    
    @IBAction func year(_ sender: Any) {
        day.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        week.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        month.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        year.backgroundColor = UIColor(red: 102/255, green: 196/255, blue: 176/255, alpha: 1);
        self.displayMarkers(time: 3)
    }
    
    
    func isValidDate(date: Date, time: integer_t) -> Bool {
        var earlyDate : Date
        if (time == 0) {
            //1 day
            earlyDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!;
            if (date >= earlyDate) {
                return true
            }
        } else if (time == 1) {
            //1 week
            earlyDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!;
            if (date >= earlyDate) {
                return true
            }
        } else if (time == 2) {
            //1 month
            earlyDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!;
            if (date >= earlyDate) {
                return true
            }
        } else if (time == 3) {
            //year
            earlyDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!;
            if (date >= earlyDate) {
                return true
            }
        }
        
        return false
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
