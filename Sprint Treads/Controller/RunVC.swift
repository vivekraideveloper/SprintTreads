//
//  RunVC.swift
//  Sprint Treads
//
//  Created by Vivek Rai on 03/11/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit
import MapKit

class RunVC: LocationVC {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var closeButtonLabel: UIButton!
    @IBOutlet weak var lastRunView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.startUpdatingLocation()
        getLastRun()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    func getLastRun(){
        guard let lastRun = Run.getAllRuns()?.first else{
            lastRunView.isHidden = true
            closeButtonLabel.isHidden = true
            return
        }
        
        lastRunView.isHidden = false
        closeButtonLabel.isHidden = false
        
        paceLabel.text = lastRun.pace.formatTimeDurationToString()
        durationLabel.text = lastRun.duration.formatTimeDurationToString()
        distanceLabel.text = "\(lastRun.distance.metresToMiles(places: 2)) mi"
    }
    
    @IBAction func locationCentreButtonPressed(_ sender: Any) {
        
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        lastRunView.isHidden = true
    }
    
}

extension RunVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
    
}

