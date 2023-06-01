//
//  CafeViewController.swift
//  O-Coffee
//
//  Created by admin on 22.05.2023.
//

import UIKit
import FirebaseStorage

class CafeViewController: UIViewController, UIScrollViewDelegate {
    
    public var cafeId: String?
    
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
        isClosed()
        setup()
    }
    
    @IBAction func ShowMenuTaped(_ sender: RoundedButton) {
        print("Click")
        performSegue(withIdentifier: "menu", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "menu":
            let controller = segue.destination as! MenuViewController
            controller.cafe = cafe
            break
        default:
            break
        }
    }
    
    private func setup(){
        imagesPagesControl.numberOfPages = photos.count
        imagesPagesControl.isEnabled = false
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")
        imagesCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func isClosed(){
        // get the current date and time
        let currentDateTime = Date()

        // get the user's calendar
        let userCalendar = Calendar.current

        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]

        // get the components
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
        
        
        RTDataBaseManager.shared.fetchCafeData(cafeId: cafeId!, completion: { result in
            switch result {
            case .success(let userData):
                
                if let userData = userData {
                    self.imagesPagesControl.numberOfPages = userData.imagesURL.count
                    self.downloadImages(imagesURL: userData.imagesURL)
                    self.nameLabel.text = userData.name
                } else {
                    // User data not found
                    print("User data not found")
                }
            case .failure(let error):
                // Handle error
                print("Error fetching user data: \(error.localizedDescription)")
            }
        })
    }
    
    private func downloadImages(imagesURL: [String: String]){
        for urls in imagesURL {
            let url = URL(string: urls.value)!
            getData(from: url, completion: { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                // always update the UI from the main thread
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
