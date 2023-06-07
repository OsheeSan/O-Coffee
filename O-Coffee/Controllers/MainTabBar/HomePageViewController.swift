//
//  HomePageViewController.swift
//  O-Coffee
//
//  Created by admin on 05.05.2023.
//

import UIKit

class HomePageViewController: UIViewController {
    
    enum State {
        case cafe
        case coffee
    }
    
    var cafes: [Cafe] = []
    var coffies: [Coffee] = []
    
    var menuState: State = .cafe

    @IBAction func createAnOrder(_ sender: RoundedButton) {
        print(OrderManager.shared.order)
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func SegmentControlChange(_ sender: UISegmentedControl) {
        Vibration.light.vibrate()
        switch sender.selectedSegmentIndex {
        case 0:
            menuState = .cafe
            print(menuState)
            break
        case 1:
            menuState = .coffee
            print(menuState)
            break
        default:
            break
        }
        UIView.transition(with: tableView,
                                  duration: 0.2,
                          options: .transitionCrossDissolve,
                                  animations:
        { () -> Void in
            self.tableView.reloadData()
        },
                                  completion: nil);
    }
    
    private func loadData(){
        DispatchQueue.global().async {
            let databaseManager = RTDataBaseManager.shared
            databaseManager.fetchAllCafes { result in
                switch result {
                case .success(let cafes):
                    for (cafeId, cafe) in cafes {
                        print("Cafe ID: \(cafeId)")
                        print("Cafe name: \(cafe.name)")
                        print("Cafe email: \(cafe.email)")
                        print("Cafe coordinates: \(cafe.coordinates)")
                        print("Cafe annotation: \(cafe.annotation)")
                        self.cafes.append(cafe)
                        UIView.transition(with: self.tableView,
                                                  duration: 0.35,
                                          options: .transitionCrossDissolve,
                                                  animations:
                        { () -> Void in
                            self.tableView.reloadData()
                        },
                                                  completion: nil);
                    }
                case .failure(let error):
                    print("Error fetching cafes data: \(error.localizedDescription)")
                }
            }
        }
        DispatchQueue.global().async {
            let databaseManager = RTDataBaseManager.shared
            databaseManager.fetchAllCoffies { result in
                switch result {
                case .success(let cofies):
                    for (coffeeId, coffee) in cofies {
                        self.coffies.append(coffee)
                        UIView.transition(with: self.tableView,
                                                  duration: 0.35,
                                          options: .transitionCrossDissolve,
                                                  animations:
                        { () -> Void in
                            self.tableView.reloadData()
                        },
                                                  completion: nil);
                    }
                case .failure(let error):
                    print("Error fetching cafes data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.backgroundColor = .clear
        setupSegmentControl()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "coffee":
            let controller = segue.destination as! CoffeeViewController
            controller.coffee = coffies[sender as! Int]
            print(coffies[sender as! Int].coffeeId)
            break
        case "cafe":
            let controller = segue.destination as! CafeViewController
            controller.cafe = cafes[sender as! Int]
            print(cafes[sender as! Int].cafeId)
            break
        default: break
        }
    }
    
    private func setupSegmentControl(){
        segmentControl.backgroundColor = .brown
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont(name: "Avenir Next Bold", size: 12) as Any], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.brown, NSAttributedString.Key.font : UIFont(name: "Avenir Next Bold", size: 12) as Any], for: .selected)
    }
    
}

extension HomePageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch menuState {
        case .cafe:
            return cafes.count
        case .coffee:
            return coffies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch menuState {
        case .cafe:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cafeCell")
            let nameLabel = cell?.viewWithTag(1) as! UILabel
            nameLabel.text = cafes[indexPath.row].name
            return cell ?? UITableViewCell()
        case .coffee:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cafeCell")
            let nameLabel = cell?.viewWithTag(1) as! UILabel
            nameLabel.text = coffies[indexPath.row].name
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch menuState {
        case .cafe:
            print("")
            performSegue(withIdentifier: "cafe", sender: indexPath.row)
            break
        case .coffee:
            print("")
            performSegue(withIdentifier: "coffee", sender: indexPath.row)
            break
        }
    }
    
}
