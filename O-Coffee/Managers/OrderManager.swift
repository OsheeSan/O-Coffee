//
//  OrderManager.swift
//  O-Coffee
//
//  Created by admin on 02.06.2023.
//

import Foundation

class OrderManager {
    
    public var order: [(coffee: Coffee, cafe: Cafe, price: Double)] = []
    
    static var shared = OrderManager()
    
    func addItem(coffee: Coffee, cafe: Cafe, price: Double){
        order.append((coffee: coffee, cafe: cafe, price: price))
    }
    
    func totalCount() -> Double {
        var result: Double = 0
        for item in OrderManager.shared.order {
            result += item.price
        }
        return round(result * 100) / 100.0
    }
}
