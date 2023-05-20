//
//  LocationsListViewController.swift
//  O-Coffee
//
//  Created by admin on 05.05.2023.
//

import UIKit
import FirebaseAuth

class QRCodeViewController: UIViewController {

    @IBOutlet weak var QRCodeImageView: UIImageView!
    
    var UserID = "User-412441235421ds"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.QRCodeImageView.alpha = 0
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        UIView.animate(withDuration: 1, animations: {
            self.QRCodeImageView.alpha = 1
        })
        let QRimage = generateQRCode(from: userId)
        self.QRCodeImageView.image = QRimage
        
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        var jsonDict = [String: Any]()
        jsonDict.updateValue(string, forKey: "UserID")
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [.prettyPrinted]) else {
            return UIImage()
        }
        if let QRFilter = CIFilter(name: "CIQRCodeGenerator") {
            QRFilter.setValue(jsonData, forKey: "inputMessage")
            QRFilter.setValue("Q", forKey: "inputCorrectionLevel")
            guard let QRImage = QRFilter.outputImage else {return nil}
            
            let transformScale = CGAffineTransform(scaleX: 100.0, y: 100.0)
            let scaledQRImage = QRImage.transformed(by: transformScale)
            return UIImage(ciImage: scaledQRImage)
        }
        return nil
    }

}
