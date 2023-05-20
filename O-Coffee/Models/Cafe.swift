//
//  Cafe.swift
//  O-Coffee
//
//  Created by admin on 19.05.2023.
//

import Foundation
import MapKit


class Cafe {
    
    var cafeId: String
    var name: String
    var email: String
    var coordinates: CLLocationCoordinate2D
    var annotation: String
    
    init(cafeId: String, name: String, email: String, coordinates: CLLocationCoordinate2D, annotation: String) {
        self.cafeId = cafeId
        self.name = name
        self.email = email
        self.coordinates = coordinates
        self.annotation = annotation
    }
    
    func toString() -> String {
        return "\ncafeId : \(cafeId) name : \(name); coordinates: \(coordinates)"
    }
}
