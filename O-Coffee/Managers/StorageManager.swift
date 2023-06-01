//
//  StorageManager.swift
//  O-Coffee
//
//  Created by admin on 26.05.2023.
//

import Foundation
import FirebaseStorage

class StorageManager {
    
    
    public func downloadload(_ cafeID: String) {
        let ref = Storage.storage().reference().child("cafeImg").child(cafeID)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
    }
    
}
