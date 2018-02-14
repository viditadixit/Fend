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

    var googleMapsView: GMSMapView!
    var placesClient: GMSPlacesClient!

        override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        searchMaps.delegate = self
        
        self.googleMapsView = GMSMapView(frame: self.googleMapsContainer.frame)
        googleMapsView.settings.myLocationButton = true
        googleMapsView.isMyLocationEnabled = true
        searchMaps.layer.borderWidth = 0.5
            
        self.view.addSubview(googleMapsView)
        googleMapsView.addSubview(searchMaps)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
