//
//  CoffeeViewController.swift
//  O-Coffee
//
//  Created by admin on 22.05.2023.
//

import UIKit

class CoffeeViewController: UIViewController, UIScrollViewDelegate {

    private var coffee = "" {
        didSet {
            coffeeNameLabel.text = coffee
        }
    }
    
    public var coffeeID = ""
    
    private var annotationURL = ""
    
    private var coffeeImage: UIImage = UIImage() {
        didSet{
            coffeeImageView.image = coffeeImage
        }
    }
    
    @IBOutlet weak var coffeeImageView: UIImageView!
    
    @IBOutlet weak var coffeeNameLabel: UILabel!
    
    @IBAction func addToOrderButtonTaped(_ sender: UIButton) {
    }
    
    @IBAction func showRecepyButtonTaped(_ sender: UIButton) {
        if let url = URL(string: annotationURL) {
            UIApplication.shared.open(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData(){
        RTDataBaseManager.shared.fetchCoffeeData(coffeeId: coffeeID, completion: { result in
            switch result {
            case .success(let coffeeData):
                if let coffeeData = coffeeData {
                    self.coffee = coffeeData.name
                    self.annotationURL = coffeeData.annotation
                    self.downloadImages(imageURL: coffeeData.imageURL)
                } else {
                    // User data not found
                    print("Coffee data not found")
                }
            case .failure(let error):
                // Handle error
                print("Error fetching coffee data: \(error.localizedDescription)")
            }
        })
    }
    
    private func downloadImages(imageURL: String){
            let url = URL(string: imageURL)!
            getData(from: url, completion: { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                // always update the UI from the main thread
                DispatchQueue.main.async() { [weak self] in
                    self?.coffeeImage = (UIImage(data: data)!)
                }
            })
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    

}
