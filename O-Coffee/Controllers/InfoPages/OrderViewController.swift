//
//  OrderViewController.swift
//  O-Coffee
//
//  Created by admin on 07.06.2023.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet weak var TotalPriceLabel: UILabel!
    
    var order = OrderManager.shared.order
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TotalPriceLabel.text = ("$\(OrderManager.shared.totalCount())")
    }

}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let uniqueCafes = Set(order.map { $0.cafe })
        return uniqueCafes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
