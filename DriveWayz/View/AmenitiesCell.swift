//
//  AmenitiesCell.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import UIKit

class AmenitiesCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            let tintedImage = image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            iconImageView.setImage(tintedImage, for: .normal)
            iconImageView.tintColor = Theme.WHITE
        }
    }
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.PACIFIC_BLUE
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let iconImageView: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.imageEdgeInsets = UIEdgeInsets(top: 16, left: 4, bottom: 16, right: 4)
        
        return view
    }()
    
    var iconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH6
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(cellView)
        cellView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24).isActive = true
        
        self.addSubview(iconImageView)
        iconImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 12).isActive = true
        iconImageView.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -12).isActive = true
        iconImageView.topAnchor.constraint(equalTo: cellView.topAnchor).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor).isActive = true
        
        self.addSubview(iconLabel)
        iconLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        iconLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        iconLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        iconLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

