//
//  CafeViewController.swift
//  O-Coffee
//
//  Created by admin on 22.05.2023.
//

import UIKit
import FirebaseStorage

class CafeViewController: UIViewController, UIScrollViewDelegate {
    
    public var cafe: Cafe?
    
    private var photos: [UIImage] = []
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var imagesPagesControl: UIPageControl!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setup()
        isClosed()
    }
    
    @IBAction func ShowMenuTaped(_ sender: RoundedButton) {
        performSegue(withIdentifier: "menu", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "menu":
            let controller = segue.destination as! MenuViewController
            controller.delegate = self
            controller.cafe = cafe
            break
        default:
            break
        }
    }
    
    private func setup(){
        imagesPagesControl.isEnabled = false
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")
        imagesCollectionView.showsHorizontalScrollIndicator = false
    }
    
    public func showCoffee(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Coffee") as! CoffeeViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    private func isClosed(){
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        switch dateTimeComponents.hour! {
        case 0...8  :
            timeLabel.text = "Closed "
            break
        case 8...22 :
            timeLabel.text = "Open"
            break
        case 22...24 :
            timeLabel.text = "Closed"
            break
        default:
            break
        }
    }
    
    private func loadData(){
        imagesPagesControl.numberOfPages = cafe!.imagesURL.count
        downloadImages(imagesURL: cafe!.imagesURL)
        nameLabel.text = cafe!.name
    }
    
    private func downloadImages(imagesURL: [String: String]){
        for urls in imagesURL {
            let url = URL(string: urls.value)!
            getData(from: url, completion: { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() { [weak self] in
                    self?.photos.append(UIImage(data: data)!)
                    self?.imagesCollectionView.reloadData()
                }
            })
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

extension CafeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) //as! PhotoCollectionViewCell
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        print(imageView.frame)
        imageView.image = photos[indexPath.row]
        cell.addSubview(imageView)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = (scrollView.contentOffset.x + scrollView.frame.width/2) / scrollView.frame.width
        imagesPagesControl.currentPage = Int(scrollPos)
    }
    
    
}
