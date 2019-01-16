//
//  LocationVC.swift
//  Sprint Treads
//
//  Created by Vivek Rai on 16/01/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit
import MapKit

class LocationVC: UIViewController, MKMapViewDelegate {
    
    var manager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.activityType = .fitness
    }
    
    func checkLocationAuthStatus(){
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse{
            manager?.requestWhenInUseAuthorization()
        }
        
    }
    
}
