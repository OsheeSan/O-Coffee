//
//  Cafe.swift
//  O-Coffee
//
//  Created by admin on 19.05.2023.
//

import Foundation
import MapKit


struct Cafe {
    
    var cafeId: String
    var name: String
    var email: String
    var coordinates: CLLocationCoordinate2D
    var annotation: String
    var imagesURL: [String:String]
    var menu: [String: [String: Any]]?
    
    init(cafeId: String, name: String, email: String, coordinates: CLLocationCoordinate2D, annotation: String, imagesURL: [String:String]) {
        self.cafeId = cafeId
        self.name = name
        self.email = email
        self.coordinates = coordinates
        self.annotation = annotation
        self.imagesURL = imagesURL
        self.menu = nil
    }
    
    init(cafeId: String, name: String, email: String, coordinates: CLLocationCoordinate2D, annotation: String, imagesURL: [String:String], menu: [String: [String: Any]]) {
        self.cafeId = cafeId
        self.name = name
        self.email = email
        self.coordinates = coordinates
        self.annotation = annotation
        self.imagesURL = imagesURL
        self.menu = menu
    }
                                                                                                                                                  func toString() -> String {
        return "\ncafeId : \(cafeId) name : \(name); coordinates: \(coordinates)"
    }
                                                                                                                                                  }
