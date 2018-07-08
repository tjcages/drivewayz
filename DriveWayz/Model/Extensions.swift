//
//  Extensions.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/24/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        if url == nil {
            self.image = UIImage(named: "profileprofile")
            return
        } else {
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                //download hit an error so lets return out
                if let error = error {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                        
                        self.image = downloadedImage
                    } else {return}
                })
                
            }).resume()
        }
    }
    
    //    func fetchUserAndSetup() {
    //        guard let uid = Auth.auth().currentUser?.uid else {
    //            return
    //        }
    //        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
    //            if let dictionary = snapshot.value as? [String:AnyObject] {
    //                let userName = dictionary["name"] as? String
    //                let userEmail = dictionary["email"] as? String
    //                let userPicture = dictionary["picture"] as? String
    //            }
    //        }, withCancel: nil)
    //    }
}
