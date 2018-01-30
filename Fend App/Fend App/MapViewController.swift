//
//  MapViewController.swift
//  Fend App
//
//  Created by Vidita Dixit on 1/30/18.
//  Copyright © 2018 Fend. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var googleMapsContainer: UIView!
    var googleMapsView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.googleMapsView = GMSMapView(frame: self.googleMapsContainer.frame)
        self.view.addSubview(googleMapsView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
