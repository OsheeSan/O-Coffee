//
//  MapViewController.swift
//  O-Coffee
//
//  Created by admin on 06.05.2023.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    
    var loc = 0
    
    var cafes: [String : Cafe] = [:]
    
    @IBOutlet private var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
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
                        
                        let annotation = CustomAnnotation()
                        var image = UIImage(named: "pin")
                        image = image?.resizeImage(targetSize: CGSize(width: 70, height: 70))
                        annotation.pinCustomImage = image
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
            if loc == 0 {
                self.mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
                loc += 1
            }
        }
    }
    
}

extension UIImage {
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
  }
}

class CustomAnnotation: MKPointAnnotation {
    var pinCustomImage: UIImage!
}

class CustomAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        update(for: annotation)
    }

    override var annotation: MKAnnotation? { didSet { update(for: annotation) } }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func update(for annotation: MKAnnotation?) {
        image = (annotation as? CustomAnnotation)?.pinCustomImage
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

