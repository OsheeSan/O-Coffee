//
//  ProfileViewController.swift
//  O-Coffee
//
//  Created by admin on 05.05.2023.
//

import UIKit

class ProfileViewController: UIViewController,  UIScrollViewDelegate, CALayerDelegate{
    
    //User Info Variables
    
    var username = "CoffeeLover"
    var coffeeCoins = 0
    
    @IBOutlet weak var BonusesView: RoundedView!
    @IBOutlet weak var NameView: RoundedView!
    
    //Card Labels
    @IBOutlet weak var CoffeeCoinsCountLabel: UILabel!
    @IBOutlet weak var UserNameLabel: UILabel!
    
    private var NameCardIsShowed = true
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    private var gradient: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScrollView.delegate = self
        gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0, 0.025]
        gradient.delegate = self
        ScrollView.layer.mask = gradient
        setupCardView()
    }
    
    //MARK: - Card View
    
    private func setupCardView(){
        self.NameView.layer.zPosition = 1
        self.BonusesView.layer.zPosition = 0
        NameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchCard)))
        BonusesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchCard)))
        setupCardLabels()
    }
    
    func setupCardLabels(){
        UserNameLabel.text = username
        CoffeeCoinsCountLabel.text = "Coins:  \(coffeeCoins)"
    }
    
    @objc private func switchCard(){
        if NameCardIsShowed {
            UIView.transition(with: self.NameView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                UIView.transition(with: self.BonusesView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                    self.NameView.layer.zPosition = 0
                    self.BonusesView.layer.zPosition = 1
                }, completion: {_ in
                })
            }, completion: nil)
        } else {
            UIView.transition(with: self.NameView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                UIView.transition(with: self.BonusesView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                    self.NameView.layer.zPosition = 1
                    self.BonusesView.layer.zPosition = 0
                }, completion: {_ in
                })
            }, completion: nil)
        }
        NameCardIsShowed.toggle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrame()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateGradientFrame()
    }
    
    func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
    
    private func updateGradientFrame() {
        gradient.frame = CGRect(
            x: 0,
            y: ScrollView.contentOffset.y,
            width: ScrollView.bounds.width,
            height: ScrollView.bounds.height
        )
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}


