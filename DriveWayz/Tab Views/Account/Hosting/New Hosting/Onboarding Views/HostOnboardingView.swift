//
//  FirstHostOnboardingView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/22/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class HostOnboardingView: UIViewController {
    
    var multiplier: CGFloat = 0.77333
    var index: Int = 0 {
        didSet {
            if index == 0 {
                multiplier = 0.77333
                let image = UIImage(named: "hostAvailability")
                mainGraphic.image = image
                
                setMainText(text: "Earn the way \nyou want")
                
                switch device {
                case .iphone8:
                    subLabel.text = "Customize the availability of your space or mark inactive whenever you need it back."
                case .iphoneX:
                    subLabel.text = "Customize the availability of your \nspace or mark inactive whenever \nyou need it back."
                }
            } else if index == 1 {
                multiplier = 0.797333
                let image = UIImage(named: "hostEarnings")
                mainGraphic.image = image
                
                setMainText(text: "Make money \nwhile you sleep")
                
                switch device {
                case .iphone8:
                    subLabel.text = "Watch the cash flow in, promote your spot in-app, or monitor analytics with ease."
                case .iphoneX:
                    subLabel.text = "Watch the cash flow in, promote \nyour spot in-app, or monitor \nanalytics with ease."
                }
            } else if index == 2 {
                multiplier = 0.744
                let image = UIImage(named: "hostAccount")
                mainGraphic.image = image
                
                setMainText(text: "Get more from your \nparking spaces")

                switch device {
                case .iphone8:
                    subLabel.text = "Increase revenue, promote your business, and help the local community by listing on Drivewayz."
                case .iphoneX:
                    subLabel.text = "Increase revenue, promote your \nbusiness, and help the local \ncommunity by listing on Drivewayz."
                }
            }
        }
    }
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.numberOfLines = 2
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.numberOfLines = 3
        
        switch device {
        case .iphone8:
            label.font = Fonts.SSPRegularH4
        case .iphoneX:
            label.font = Fonts.SSPRegularH3
        }
        
        return label
    }()
    
    var mainGraphic: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(mainGraphic)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        switch device {
        case .iphone8:
            mainLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: gradientHeight - 4).isActive = true
        case .iphoneX:
            mainLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: gradientHeight - 16).isActive = true
        }
        
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subLabel.sizeToFit()
        switch device {
        case .iphone8:
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0).isActive = true
        case .iphoneX:
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        }
        
        mainGraphic.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        mainGraphic.heightAnchor.constraint(equalTo: mainGraphic.widthAnchor, multiplier: multiplier).isActive = true
        
    }

    func setMainText(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 34
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        mainLabel.attributedText = attrString
    }
    
}
