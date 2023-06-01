//
//  ProfileViewController.swift
//  O-Coffee
//
//  Created by admin on 05.05.2023.
//

import UIKit
import FirebaseAuth
import MessageUI

class ProfileViewController: UIViewController,  UIScrollViewDelegate, CALayerDelegate, MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["antonbabko39@gmail.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    //User Info Variables
    
    var CurrentUsername = "" {
        didSet {
            UserNameLabel.text = CurrentUsername
        }
    }
    var coffeeCoins = 0 {
        didSet {
            CoffeeCoinsCountLabel.text = "Coins: \(coffeeCoins)"
        }
    }
    
    //CARD
    
    @IBOutlet weak var BonusesView: RoundedView!
    @IBOutlet weak var NameView: RoundedView!
    
    @IBOutlet weak var CoffeeCoinsCountLabel: UILabel!
    @IBOutlet weak var UserNameLabel: UILabel!
    
    private var NameCardIsShowed = true
    
    private var CardIsShowed = true
    
    
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    private var gradient: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendEmail()
        loadData()
        ScrollView.delegate = self
        gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0, 0.025]
        gradient.delegate = self
        ScrollView.layer.mask = gradient
        setupCardView()
    }
    
    private func loadData(){
        guard let userId = Auth.auth().currentUser?.uid  else {
            return
        }
        RTDataBaseManager.shared.fetchUserData(userId: userId) { result in
            switch result {
            case .success(let userData):
                if let userData = userData {
                    if let username = userData["username"] as? String {
                        self.CurrentUsername = username
                    }
                    if let coins = userData["coins"] as? Int {
                        self.coffeeCoins = coins
                    }
                } else {
                    // User data not found
                    print("User data not found")
                }
            case .failure(let error):
                // Handle error
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
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
        UserNameLabel.text = CurrentUsername
        CoffeeCoinsCountLabel.text = "Coins:  \(coffeeCoins)"
    }
    
    @objc private func switchCard(){
        if NameCardIsShowed {
            UIView.transition(with: self.NameView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                UIView.transition(with: self.BonusesView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                    self.NameView.layer.zPosition = 0
                    self.BonusesView.layer.zPosition = 1
                    self.NameCardIsShowed = false
                }, completion: {_ in
                })
            }, completion: nil)
        } else {
            UIView.transition(with: self.NameView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                UIView.transition(with: self.BonusesView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                    self.NameView.layer.zPosition = 1
                    self.BonusesView.layer.zPosition = 0
                    self.NameCardIsShowed = true
                }, completion: {_ in
                })
            }, completion: nil)
        }
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


