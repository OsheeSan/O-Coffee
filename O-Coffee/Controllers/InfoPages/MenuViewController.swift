//
//  MenuViewController.swift
//  O-Coffee
//
//  Created by admin on 01.06.2023.
//

import UIKit

class MenuViewController: UIViewController {
    
    public var cafe: Cafe?
    
    var menuData: [String: [String: Any]] = [:]
    var menuItems: [(id: String, name: String, price: Double)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blur()
        menuData = (cafe?.menu)!
        loadMenu()
    }
    
    private func blur(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    private func loadMenu(){
        menuItems = menuData.map { (id, itemData) in
                    let name = itemData["name"] as? String ?? ""
                    let price = itemData["price"] as? Double ?? 0.0
                    return (id: id, name: name, price: price)
                }
                
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafe!.menu!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let menuItem = menuItems[indexPath.row]
        
        let namelabel = cell.viewWithTag(1) as! UILabel
        let priceLabel = cell.viewWithTag(2) as! UILabel
        namelabel.text = menuItem.name
        priceLabel.text = "$\(menuItem.price)"
        return cell
    }
    
    
}
