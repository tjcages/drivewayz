//
//  MapMarkerWindowView.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/2/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class MapMarkerWindowView: UIView {

    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var previewCity: UILabel!
    @IBOutlet weak var previewDistance: UILabel!
    @IBOutlet weak var previewPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setData(city: String, distance: String, price: String) {
        previewCity.text = city
        previewDistance.text = "\(distance) miles"
        previewPrice.text = price
    }
    
    func setupViews() {
        
        let image = UIImage(named: "parking")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        previewImage.image = tintedImage
        previewImage.tintColor = Theme.PRIMARY_COLOR
        
        previewCity.font = UIFont.boldSystemFont(ofSize: 16)
        previewCity.textColor = Theme.PRIMARY_DARK_COLOR
//        previewCity.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        previewCity.textAlignment = .center
        previewCity.layer.cornerRadius = 5
        previewCity.clipsToBounds = true
        previewCity.translatesAutoresizingMaskIntoConstraints = false
        previewCity.numberOfLines = 3
        
        previewDistance.font = UIFont.boldSystemFont(ofSize: 15)
        previewDistance.textColor = Theme.PRIMARY_COLOR
//        previewDistance.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        previewDistance.textAlignment = .center
        previewDistance.layer.cornerRadius = 5
        previewDistance.clipsToBounds = true
        previewDistance.translatesAutoresizingMaskIntoConstraints = false
        previewDistance.numberOfLines = 1
        
        previewPrice.font = UIFont.boldSystemFont(ofSize: 16)
        previewPrice.textColor = Theme.PRIMARY_DARK_COLOR
//        previewPrice.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        previewPrice.textAlignment = .center
        previewPrice.layer.cornerRadius = 5
        previewPrice.clipsToBounds = true
        previewPrice.translatesAutoresizingMaskIntoConstraints = false

    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapMarkerWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
}
