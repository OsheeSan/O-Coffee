//
//  MenuItem.swift
//  O-Coffee
//
//  Created by admin on 01.06.2023.
//

import Foundation

class MenuItem {
    
    var CoffeeId: String
    var CoffeeName: String
    var price: Double
    var count: Int
    var cafeID: String
    var cafeCame: String
    
    init(CoffeeId: String, CoffeeName: String, price: Double, count: Int, cafeID: String, cafeCame: String) {
        self.CoffeeId = CoffeeId
        self.CoffeeName = CoffeeName
        self.price = price
        self.count = count
        self.cafeID = cafeID
        self.cafeCame = cafeCame
    }
    
}
