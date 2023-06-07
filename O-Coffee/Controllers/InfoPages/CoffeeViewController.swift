//
//  CoffeeViewController.swift
//  O-Coffee
//
//  Created by admin on 22.05.2023.
//

import UIKit

class CoffeeViewController: UIViewController, UIScrollViewDelegate {
    
    public var coffee: Coffee?
    
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
        if let url = URL(string: coffee!.annotation) {
            UIApplication.shared.open(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData(){
        coffeeNameLabel.text = coffee!.name
        downloadImages(imageURL: coffee!.imageURL)
    }
    
    private func downloadImages(imageURL: String){
            let url = URL(string: imageURL)!
            getData(from: url, completion: { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() { [weak self] in
                    self?.coffeeImage = (UIImage(data: data)!)
                }
            })
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    

}
