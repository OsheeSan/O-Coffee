//
//  MenuViewController.swift
//  O-Coffee
//
//  Created by admin on 01.06.2023.
//

import UIKit

class MenuViewController: UIViewController {
    
    public var delegate: CafeViewController?
    
    public var cafe: Cafe?
    
    var menuData: [String: [String: Any]] = [:]
    var menuItems: [(id: String, name: String, price: Double)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blur()
        menuData = (cafe?.menu)!
        loadMenu()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "coffee":
        let controller = segue.destination as! CoffeeViewController
        let coffee = sender as! Coffee
        controller.coffee = coffee
        break
    default:
        break
    }
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
    
    private func addToOrder(id: String, price: Double) {
        print("Added to order")
        DispatchQueue.global().async {
            let databaseManager = RTDataBaseManager.shared
            databaseManager.fetchCoffeeData(coffeeId: id, completion: { result in
                switch result {
                case .success(let coffee):
                    if let coffee = coffee {
                        OrderManager.shared.addItem(coffee: coffee, cafe: self.cafe!, price: price)
                    }
                    print("Added item to order")
                case .failure(let error):
                    print("Error fetching coffee data: \(error.localizedDescription)")
                }
            })
        }
    }

    
    public func showCoffee(id: String){
        DispatchQueue.global().async {
            let databaseManager = RTDataBaseManager.shared
            databaseManager.fetchCoffeeData(coffeeId: id, completion: { result in
                switch result {
                case .success(let coffee):
                    self.performSegue(withIdentifier: "coffee", sender: coffee)
                case .failure(let error):
                    print("Error fetching coffee data: \(error.localizedDescription)")
                }
            })
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
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action1 = UIContextualAction(style: .normal,
                                        title: "Add to Order") { [weak self] (action, view, completionHandler) in
                                            self?.addToOrder(id: self?.menuItems[indexPath.row].id ?? "", price: self?.menuItems[indexPath.row].price ?? 0)
                                            completionHandler(true)
        }
        action1.backgroundColor = UIColor(cgColor: CGColor(red: 218/255, green: 138/255, blue: 60/255, alpha: 1))
        return UISwipeActionsConfiguration(actions: [action1])
    }
    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action2 = UIContextualAction(style: .normal,
                                        title: "Show Info") { [weak self] (action, view, completionHandler) in
            self?.showCoffee(id: self?.menuItems[indexPath.row].id ?? "")
                                            completionHandler(true)
        }
        action2.backgroundColor = UIColor(cgColor: CGColor(red: 218/255, green: 138/255, blue: 60/255, alpha: 1))
        return UISwipeActionsConfiguration(actions: [action2])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
