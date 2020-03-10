//
//  PublicInfoView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/6/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import SVGKit

class PublicInfoView: UIView {
    
    var spotType: SpotType = .Public {
        didSet {
            switch spotType {
            case .Private:
                mainLabel.text = "Private lot"
                costLabel.text = "$7.50"
                subCostLabel.text = "Drivewayz"
                illustrationBackgroundColor = Theme.BLUE_DARK
                let image = SVGKImage(named: "Private_Parking_Illustration")
                svgIllustration.image = image
                let car = SVGKImage(named: "Car_Illustration")
                carIllustration.image = car
                carIllustration.isHidden = false
                carView.isHidden = true
            case .Public:
                mainLabel.text = "Public lot"
                costLabel.text = "$4.50/hour"
                subCostLabel.text = "ACE Parking"
                illustrationBackgroundColor = Theme.COOL_1_MED
                let image = SVGKImage(named: "Public_Illustration")
                svgIllustration.image = image
                let car = SVGKImage(named: "Car_Kiosk_Illustration")
                carIllustration.image = car
                carIllustration.isHidden = false
                carView.isHidden = false
            case .Free:
                mainLabel.text = "Mission Bay lot"
                costLabel.text = "Free"
                subCostLabel.text = "Public"
                illustrationBackgroundColor = Theme.COOL_2_MED
                let image = SVGKImage(named: "Building_Illustration")
                svgIllustration.image = image
                carIllustration.isHidden = true
                carView.isHidden = true
            }
        }
    }
    
    var illustrationBackgroundColor: UIColor = Theme.COOL_1_MED {
        didSet {
            infoView.backgroundColor = illustrationBackgroundColor
        }
    }
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = illustrationBackgroundColor
        
        return view
    }()
    
    var svgIllustration: SVGKImageView = {
        let image = SVGKImage(named: "Public_Illustration")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var carIllustration: SVGKImageView = {
        let image = SVGKImage(named: "Car_Kiosk_Illustration")
        let view = SVGKFastImageView(svgkImage: image)!
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Public lot"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH25
        
        return label
    }()
    
    var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$4.50/hour"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPSemiBoldH2
        label.textAlignment = .right
        
        return label
    }()
    
    var subCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ACE Parking"
        label.textColor = Theme.GRAY_WHITE
        label.font = Fonts.SSPRegularH4
        label.textAlignment = .right
        
        return label
    }()
    
    var carView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    var carLeftAnchor: NSLayoutConstraint!
    var carHeightAnchor: NSLayoutConstraint!
    var carBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(infoView)
        addSubview(mainLabel)
        addSubview(svgIllustration)
        addSubview(carIllustration)
        addSubview(carView)
        
        infoView.anchor(top: topAnchor, left: leftAnchor, bottom: svgIllustration.centerYAnchor, right: rightAnchor, paddingTop: -200, paddingLeft: 0, paddingBottom: -40, paddingRight: 0, width: 0, height: 0)
    
        let height = svgIllustration.image.size.height/svgIllustration.image.size.width * phoneWidth
        svgIllustration.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: height)
        
        let width = carIllustration.image.size.width/carIllustration.image.size.height
        carIllustration.widthAnchor.constraint(equalTo: carIllustration.heightAnchor, multiplier: width).isActive = true
        carIllustration.bottomAnchor.constraint(equalTo: svgIllustration.bottomAnchor).isActive = true
        carLeftAnchor = carIllustration.leftAnchor.constraint(equalTo: leftAnchor, constant: 16)
            carLeftAnchor.isActive = true
        carHeightAnchor = carIllustration.heightAnchor.constraint(equalToConstant: 69)
            carHeightAnchor.isActive = true
        
        mainLabel.topAnchor.constraint(equalTo: svgIllustration.bottomAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        addSubview(costLabel)
        addSubview(subCostLabel)
        
        costLabel.topAnchor.constraint(equalTo: mainLabel.topAnchor).isActive = true
        costLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        costLabel.sizeToFit()
        
        subCostLabel.topAnchor.constraint(equalTo: costLabel.bottomAnchor, constant: 4).isActive = true
        subCostLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        subCostLabel.sizeToFit()
        
        carView.anchor(top: carIllustration.topAnchor, left: leftAnchor, bottom: carIllustration.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 20, height: 0)
        
    }
    
    func changeCarAnchors(percent: CGFloat) {
        carLeftAnchor.constant = 16 - 44 * percent
        carHeightAnchor.constant = 69 - 13 * percent
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
