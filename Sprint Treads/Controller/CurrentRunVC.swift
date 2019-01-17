//
//  CurrentRunVC.swift
//  Sprint Treads
//
//  Created by Vivek Rai on 16/01/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class CurrentRunVC: LocationVC, UIGestureRecognizerDelegate {

    @IBOutlet weak var swipeBackGroundImageView: UIImageView!
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var pauseImageView: UIImageView!
    
    fileprivate var startLocation: CLLocation!
    fileprivate var lastLocation: CLLocation!
    fileprivate var coordinateLocations = List<Location>()
    
    fileprivate var runDistance = 0.0
    fileprivate var counter = 0
    fileprivate var timer = Timer()
    fileprivate var pace = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwipe(sender: )))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self
        
        let uiTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CurrentRunVC.pauseImageTapped))
        uiTapGestureRecognizer.delegate = self
        pauseImageView.addGestureRecognizer(uiTapGestureRecognizer)
        self.pauseImageView.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
    }
    
    func startRun(){
        manager?.startUpdatingLocation()
        startTimer()
        pauseImageView.image = UIImage(named: "pauseButton")
    }
    
    func endRun(){
        manager?.stopUpdatingLocation()
//        Add our Realm Object
        Run.addRunToRealm(pace: pace, distance: runDistance, duration: counter, locations: coordinateLocations)
        
    }
    
    func pauseRun(){
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
        manager?.stopUpdatingLocation()
        pauseImageView.image = UIImage(named: "resumeButton")
    }
    
    func startTimer(){
        durationLabel.text = counter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter(){
        counter += 1
        durationLabel.text = counter.formatTimeDurationToString()
        
    }
    
    func calculatePace(time second: Int, miles: Double) -> String{
        pace = Int(Double(second)/miles)
        return pace.formatTimeDurationToString()
    }
    
    @objc func pauseImageTapped(){
        print("Image Tapped")
        if timer.isValid{
            pauseRun()
        }else{
            startRun()
        }
        
    }
    
    @objc func endRunSwipe(sender: UIPanGestureRecognizer){
        
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat = 130
        
        if let sliderView = sender.view{
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed{
                let translation = sender.translation(in: self.view)
                if sliderView.center.x >= (swipeBackGroundImageView.center.x - minAdjust) && sliderView.center.x <= (swipeBackGroundImageView.center.x + maxAdjust){
                    sliderView.center = CGPoint(x: sliderView.center.x + translation.x, y: sliderView.center.y)
                }else if sliderView.center.x >= (swipeBackGroundImageView.center.x + maxAdjust){
                    sliderView.center.x = swipeBackGroundImageView.center.x + maxAdjust
//                    End Run Code Goes Here
                    endRun()
                    dismiss(animated: true, completion: nil)
                }else{
                    sliderView.center.x = swipeBackGroundImageView.center.x - minAdjust
                }
                
                sender.setTranslation(CGPoint.zero, in: self.view)
            }else if sender.state == UIGestureRecognizer.State.ended{
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.swipeBackGroundImageView.center.x - minAdjust
                }
            }
        }
    }
}

extension CurrentRunVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil{
            startLocation = locations.first
        }else if let location = locations.last{
            runDistance += lastLocation.distance(from: location)
            let newLocation = Location(latitude: Double(lastLocation.coordinate.latitude), longitude: Double(lastLocation.coordinate.longitude))
            coordinateLocations.insert(newLocation, at: 0)
            distanceLabel.text = "\(runDistance.metresToMiles(places: 2))"
            if counter>0 && runDistance>0{
                 paceLabel.text = calculatePace(time: counter, miles: runDistance.metresToMiles(places: 2))
            }
           
        }
        lastLocation = locations.last
    }
}
