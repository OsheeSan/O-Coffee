//
//  CafeViewController.swift
//  O-Coffee
//
//  Created by admin on 22.05.2023.
//

import UIKit

class CafeViewController: UIViewController {
    
    public var cafeId: String?
    
    private var photos: [UIImage] = [UIImage(named: "icedirishcoffee")!, UIImage(named: "icedirishcoffee")!]
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")
    }
    
    private func loadData(){
        
    }
    
}

extension CafeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) //as! PhotoCollectionViewCell
//        cell.image.image = UIImage(named: "pin")
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        print(imageView.frame)
        imageView.image = photos[indexPath.row]
        cell.addSubview(imageView)
        
        cell.backgroundColor = .orange
        return cell
    }
    
    
}
