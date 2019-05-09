//
//  DiaryLocationHelper.swift
//  Diary
//
//  Created by TaoTao on 2019/5/9.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import CoreLocation

class DiaryLocationHelper: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    var address: String?
    
    var geocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        geocoder.reverseGeocodeLocation(locations[0]) { (placemarks, error) in
            if let error = error {
                print("查询失败：\(error.localizedDescription)")
            }
            
            if let pm = placemarks {
                if pm.count > 0 {
                    let placemark = pm.first
                    self.address = placemark?.locality
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DiaryLocationUpdated"), object: self.address)
                }
            }
        }
    }
}
