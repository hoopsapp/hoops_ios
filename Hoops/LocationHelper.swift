//
//  LocationHelper.swift
//  Hoops
//
//  Created by Daniel on 08.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import Foundation
import CoreLocation

let _locationHelper = LocationHelper()

class LocationHelper: NSObject, CLLocationManagerDelegate{
    let locationManager: CLLocationManager = CLLocationManager()
    var location: (Double, Double)? //0 => Long, 1 => Lat
    var isAuthorized : Bool = false
    
    let kInvalidLocation : (Double, Double) = (-200, -200)
    let kFirstLocationNotification : String = "first_location_received"
    
    
    class func instance() -> LocationHelper{
        return _locationHelper
    }
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func askForPermission(){
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if location == nil{
            NSNotificationCenter.defaultCenter().postNotificationName(kFirstLocationNotification, object: self)
        }
        
        location = (
            locationManager.location.coordinate.longitude as Double,
            locationManager.location.coordinate.latitude as Double
        )
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog(error.description)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch(status){
        case CLAuthorizationStatus.NotDetermined:
            break
        case CLAuthorizationStatus.Restricted:
            break
        case CLAuthorizationStatus.Denied:
            break
        case CLAuthorizationStatus.Authorized:
            isAuthorized = true
            locationManager.startUpdatingLocation()
            break
        case CLAuthorizationStatus.AuthorizedWhenInUse:
            isAuthorized = true
            locationManager.startUpdatingLocation()
            break
        default:
            break
        }
    }
    
    func distanceTo(otherLocation:(Double, Double))-> Double{
        if let currentLocation = location{
            return sqrt(pow(currentLocation.0 - otherLocation.0, 2) + pow(currentLocation.1 - otherLocation.1, 2))
        }
        else {
            return 0
        }
    }
}