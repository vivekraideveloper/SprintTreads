//
//  RunVC.swift
//  Sprint Treads
//
//  Created by Vivek Rai on 03/11/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        manager?.delegate = self
        manager?.startUpdatingLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpMapView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    func setUpMapView(){
        if let overlay = addLastRunToMap(){
            if mapView.overlays.count > 0{
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
            lastRunView.isHidden = false
            closeButtonLabel.isHidden = false
        }else{
            lastRunView.isHidden = true
            closeButtonLabel.isHidden = true
            centreMapUserLocation()
        }
        
    }
    
    func addLastRunToMap() -> MKPolyline?{
        guard let lastRun = Run.getAllRuns()?.first else {return nil}
            paceLabel.text = lastRun.pace.formatTimeDurationToString()
            durationLabel.text = lastRun.duration.formatTimeDurationToString()
            distanceLabel.text = "\(lastRun.distance.metresToMiles(places: 2)) mi"
        var coordinate = [CLLocationCoordinate2D]()
        
        for location in lastRun.locations{
            coordinate.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        
        mapView.userTrackingMode = .none
        mapView.setRegion(centreMapOnPreviousRoute(locations: lastRun.locations), animated: true)
        
        return MKPolyline(coordinates: coordinate, count: lastRun.locations.count)
    }
    
    func centreMapUserLocation(){
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centreMapOnPreviousRoute(locations: List<Location>) -> MKCoordinateRegion{
        
        guard let initialLocation = locations.first else {  return MKCoordinateRegion()}
        var minLatitude = initialLocation.latitude
        var minLongitude = initialLocation.longitude
        var maxLatitude = minLatitude
        var maxLongitude = minLongitude
        
        for location in locations{
            minLatitude = min(minLatitude, location.latitude)
            minLongitude = min(minLongitude, location.longitude)
            maxLatitude = max(maxLatitude, location.latitude)
            maxLongitude = max(maxLongitude, location.longitude)
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLatitude+maxLatitude)/2, longitude: (minLongitude+maxLongitude)/2), span: MKCoordinateSpan(latitudeDelta: (maxLatitude-minLatitude)*1.4, longitudeDelta: (maxLongitude-minLongitude)*1.4))
    }
    
    
    @IBAction func locationCentreButtonPressed(_ sender: Any) {
        centreMapUserLocation()
        
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        lastRunView.isHidden = true
        centreMapUserLocation()
    }
    
}

extension RunVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLine = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = UIColor.orange
        renderer.lineWidth = 4
        return renderer
    }
    
}

