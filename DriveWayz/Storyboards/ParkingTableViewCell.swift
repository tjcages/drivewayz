//
//  ParkingTableViewCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/28/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit

class ParkingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var parkingSpotImage: UIImageView!
    @IBOutlet weak var parkingSpotCity: UILabel!
    @IBOutlet weak var parkingSpotCost: UILabel!
    @IBOutlet weak var parkingDistance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
        
        parkingSpotCity.textColor = Theme.PRIMARY_DARK_COLOR
        parkingSpotCost.textColor = Theme.PRIMARY_DARK_COLOR
        parkingDistance.textColor = Theme.PRIMARY_DARK_COLOR.withAlphaComponent(0.7)
        parkingDistance.textAlignment = .center
    }
    
    
    private func setupShadow() {
        cellView.layer.cornerRadius = 8
        cellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cellView.layer.shadowRadius = 3
        cellView.layer.shadowOpacity = 0.3
        cellView.layer.shadowPath = UIBezierPath(roundedRect: cellView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        cellView.layer.backgroundColor = UIColor.white.cgColor
        cellView.layer.shouldRasterize = true
        cellView.layer.rasterizationScale = UIScreen.main.scale
        
        parkingSpotImage.layer.cornerRadius = 4
        parkingSpotImage.layer.shadowOffset = CGSize(width: -1, height: 1)
        parkingSpotImage.layer.shadowRadius = 1
        parkingSpotImage.layer.shadowOpacity = 0.3
        parkingSpotImage.layer.shadowPath = UIBezierPath(roundedRect: parkingSpotImage.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 4, height: 4)).cgPath
        parkingSpotImage.layer.shouldRasterize = true
        parkingSpotImage.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = UIColor.white
        super.setHighlighted(highlighted, animated: animated)
        self.cellView.backgroundColor = color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
