//
//  Coffee.swift
//  O-Coffee
//
//  Created by admin on 20.05.2023.
//

import Foundation

class Coffee {
    
    var coffeeId: String
    var name: String
    var annotation: String
    var imageURL: String
    
    init(coffeeId: String, name: String, annotation: String, imageURL: String) {
        self.coffeeId = coffeeId
        self.name = name
        self.annotation = annotation
        self.imageURL = imageURL
    }
    
}
