//
//  PhotoCollectionViewCell.swift
//  O-Coffee
//
//  Created by admin on 23.05.2023.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    public var image: UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(image)
        backgroundColor = .brown
        image.frame = contentView.frame
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
