//
//  MapViewController.swift
//  O-Coffee
//
//  Created by admin on 06.05.2023.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var cafes: [String : Cafe] = [:]
    
    @IBOutlet private var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        placemnarks()
        loadCafe()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
                self.mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
            }
        }
    }
    
    func loadCafe(){
        DispatchQueue.global().async {
            let databaseManager = RTDataBaseManager.shared
            databaseManager.fetchAllCafes { result in
                switch result {
                case .success(let cafes):
                    // Cafes data retrieved successfully
                    for (cafeId, cafe) in cafes {
                        
                        print("Cafe ID: \(cafeId)")
                        print("Cafe name: \(cafe.name)")
                        print("Cafe email: \(cafe.email)")
                        print("Cafe coordinates: \(cafe.coordinates)")
                        print("Cafe annotation: \(cafe.annotation)")
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: cafe.coordinates.latitude, longitude: cafe.coordinates.longitude)
                        annotation.title = cafe.name
                        annotation.subtitle = cafe.annotation
                        self.mapView.addAnnotation(annotation)
                    }
                case .failure(let error):
                    // Handle error
                    print("Error fetching cafes data: \(error.localizedDescription)")
                }
            }
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
    }
    
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

