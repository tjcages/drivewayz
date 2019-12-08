//
//  ProfitsTransfersViewController
//  DriveWayz
//
//  Created by Tyler J. Cagle on 7/24/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class ProfitsTransfersViewController: UIViewController {
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let background = CAGradientLayer().customColor(topColor: Theme.LightPurple, bottomColor: Theme.DarkBlue)
        background.frame = CGRect(x: 0, y: 0, width: phoneWidth, height: phoneWidth * 0.42)
        background.zPosition = -10
        view.layer.addSublayer(background)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    var gooGraphic: UIImageView = {
        let image = UIImage(named: "gooGraphic")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var totalEarnings: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.text = "$0.00"
        label.font = Fonts.SSPBoldH0
        
        return label
    }()
    
    var datesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.6)
        label.text = "TOTAL PAYOUTS"
        label.font = Fonts.SSPRegularH6
        
        return label
    }()
    
    var transferButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "openDots")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        return button
    }()
    
    var futureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE.withAlphaComponent(0.8)
        label.text = "$0.00 in transit to bank"
        label.font = Fonts.SSPSemiBoldH4
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(container)
        container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        container.addSubview(gooGraphic)
        gooGraphic.widthAnchor.constraint(equalToConstant: 300).isActive = true
        gooGraphic.heightAnchor.constraint(equalToConstant: 300).isActive = true
        gooGraphic.centerXAnchor.constraint(equalTo: container.rightAnchor, constant: -40).isActive = true
        gooGraphic.centerYAnchor.constraint(equalTo: container.bottomAnchor, constant: -80).isActive = true
        
        self.view.addSubview(datesLabel)
        datesLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 24).isActive = true
        datesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        datesLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        datesLabel.sizeToFit()
        
        self.view.addSubview(totalEarnings)
        totalEarnings.topAnchor.constraint(equalTo: datesLabel.bottomAnchor, constant: 0).isActive = true
        totalEarnings.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        totalEarnings.sizeToFit()
        
        self.view.addSubview(futureLabel)
        futureLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24).isActive = true
        futureLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        futureLabel.sizeToFit()
        
        self.view.addSubview(transferButton)
        transferButton.centerYAnchor.constraint(equalTo: datesLabel.centerYAnchor).isActive = true
        transferButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -4).isActive = true
        transferButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        transferButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        
    }

}
