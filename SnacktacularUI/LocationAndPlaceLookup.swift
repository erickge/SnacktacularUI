//
//  LocationAndPlaceLookup.swift
//  LocationAndPlaceLookup
//
//  Created by Gary Erickson on 5/27/25.
//

import Foundation
import MapKit
import SwiftUI

@Observable

class LocationManager: NSObject, CLLocationManagerDelegate {
    //*** CRITICALLY Important *** Always add intoplist message for Privacy - Location When in Use Useage Description
    
    var location: CLLocation?
    var placemark: CLPlacemark?
    private let locationManager = CLLocationManager()
    var errorMessage: String?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var locationUpdated: ((CLLocation) -> Void)? // This is a function that can be called, passing in a location
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    // Get a region around current location with specified radius in meters
    func getRegionAroundCurrentLocation(radiusInMeters: CLLocationDistance = 10000) -> MKCoordinateRegion? {
        guard let location = location else { return nil }
        
        return MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: radiusInMeters,
            longitudinalMeters: radiusInMeters
        )
        
        
    }
}
extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let newLocation = locations.last else { return }
        location = newLocation
        // Call the callback function to indicate we've updated a location
        locationUpdated?(newLocation)
        
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedAlways,.authorizedWhenInUse:
            print ("locationManager authorization granted")
            manager.startUpdatingLocation()
        case .denied,.restricted:
            print ("locationManager authorization denied")
            errorMessage = "LocationManager access denied"
            manager.stopUpdatingLocation()
        case .notDetermined:
            print ("locationManager authorization not determined")
            manager.requestWhenInUseAuthorization()
        @unknown default:
            manager.requestWhenInUseAuthorization()

            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        errorMessage = error.localizedDescription
        print("😡 ERROR LocationManger: \(errorMessage ?? "No Error") ")
    }
}
