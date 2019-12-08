//
//  HelpAccountInformationView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 11/18/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import Cosmos

class HelpAccountInformationView: UIViewController {

    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()
    
    var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Let's Get Started", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.backgroundColor = Theme.DARK_GRAY
        button.titleLabel?.font = Fonts.SSPSemiBoldH3
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You can always change listing \npreferences in the host portal."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    var mainIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "mainQuickHost")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.PRUSSIAN_BLUE
        button.isUserInteractionEnabled = false
        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Monitor all your listings \nfrom one place"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH1
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "List your unused parking spaces to \nhelp others in your community."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 2
        
        return label
    }()
    
    var currentAccountView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var spotIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 95/2
        let image = UIImage(named: "Residential Home Driveway")
        view.image = image
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        
        return view
    }()
    
    var starView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.DARK_GRAY
        view.layer.cornerRadius = 14
        
        return view
    }()
    
    var stars: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.totalStars = 1
        view.settings.updateOnTouch = false
        view.settings.starSize = 14
        view.settings.starMargin = 2
        view.settings.filledColor = Theme.WHITE
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.text = "4.91"
        view.settings.textFont = Fonts.SSPSemiBoldH5
        view.settings.textColor = Theme.WHITE
        view.settings.textMargin = 8
        view.settings.filledImage = UIImage(named: "Star Filled White")
        
        return view
    }()

    var spotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Prime"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPSemiBoldH2
        
        return label
    }()
    
    var subSpotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2-Car Residential"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH3
        
        return label
    }()
    
    var spotInformationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Closest spot to your destination"
        label.textColor = lineColor
        label.font = Fonts.SSPRegularH6
        
        return label
    }()
    
    var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$3.17/hour"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH2
        label.textAlignment = .right
        
        return label
    }()
    
    var rankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Highly ranked"
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPRegularH5
        label.textAlignment = .right
        
        return label
    }()
    
    var primeIcon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "verificationIcon")
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.HARMONY_RED
        
        let check = UIButton(frame: CGRect(x: 2, y: 2, width: 14, height: 14))
        let origImage2 = UIImage(named: "Checkmark")
        let tintedImage2 = origImage2?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        check.setImage(tintedImage2, for: .normal)
        check.tintColor = Theme.WHITE
        button.addSubview(check)
        
        return button
    }()
    
    var nextSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Edit information on the fly so drivers \nknow what to expect."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 2
        
        return label
    }()
    
    var privacyContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        
        return view
    }()
    
    var nextMainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Privacy is key"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPSemiBoldH1
        
        return label
    }()
    
    var lockView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "flat-lock")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()

    var lastSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your information is secure through \nthe whole booking process."
        label.textColor = Theme.PRUSSIAN_BLUE
        label.font = Fonts.SSPRegularH3
        label.numberOfLines = 2
        
        return label
    }()
    
    var worksView: HelpWorksView = {
        let view = HelpWorksView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.index = 2
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        view.translatesAutoresizingMaskIntoConstraints = false

        setupViews()
        setupDetails()
        setupAccount()
        setupMainButton()
    }
    
    func setupViews() {
        
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.sizeToFit()
        
        view.addSubview(currentAccountView)
        currentAccountView.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 228)
        
    }
    
    func setupDetails() {
        
        view.addSubview(spotIcon)
        spotIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spotIcon.topAnchor.constraint(equalTo: currentAccountView.topAnchor, constant: 20).isActive = true
        spotIcon.widthAnchor.constraint(equalToConstant: 95).isActive = true
        spotIcon.heightAnchor.constraint(equalTo: spotIcon.widthAnchor).isActive = true
        
        view.addSubview(starView)
        starView.centerXAnchor.constraint(equalTo: spotIcon.centerXAnchor).isActive = true
        starView.centerYAnchor.constraint(equalTo: spotIcon.bottomAnchor, constant: -8).isActive = true
        starView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        starView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        starView.addSubview(stars)
        stars.centerXAnchor.constraint(equalTo: starView.centerXAnchor).isActive = true
        stars.centerYAnchor.constraint(equalTo: starView.centerYAnchor, constant: 1).isActive = true
        stars.sizeToFit()
        
        view.addSubview(spotLabel)
        view.addSubview(primeIcon)
        
        spotLabel.topAnchor.constraint(equalTo: starView.bottomAnchor, constant: 8).isActive = true
        spotLabel.leftAnchor.constraint(equalTo: currentAccountView.leftAnchor, constant: 20).isActive = true
        spotLabel.sizeToFit()
        
        primeIcon.centerYAnchor.constraint(equalTo: spotLabel.centerYAnchor).isActive = true
        primeIcon.leftAnchor.constraint(equalTo: spotLabel.rightAnchor, constant: 8).isActive = true
        primeIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        primeIcon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        view.addSubview(subSpotLabel)
        subSpotLabel.topAnchor.constraint(equalTo: spotLabel.bottomAnchor, constant: 0).isActive = true
        subSpotLabel.leftAnchor.constraint(equalTo: spotLabel.leftAnchor).isActive = true
        subSpotLabel.sizeToFit()
        
        view.addSubview(spotInformationLabel)
        spotInformationLabel.topAnchor.constraint(equalTo: subSpotLabel.bottomAnchor, constant: 0).isActive = true
        spotInformationLabel.leftAnchor.constraint(equalTo: spotLabel.leftAnchor).isActive = true
        spotInformationLabel.sizeToFit()
        
        view.addSubview(costLabel)
        costLabel.topAnchor.constraint(equalTo: spotLabel.topAnchor).isActive = true
        costLabel.rightAnchor.constraint(equalTo: currentAccountView.rightAnchor, constant: -20).isActive = true
        costLabel.sizeToFit()
        
        view.addSubview(rankLabel)
        rankLabel.topAnchor.constraint(equalTo: costLabel.bottomAnchor).isActive = true
        rankLabel.rightAnchor.constraint(equalTo: currentAccountView.rightAnchor, constant: -20).isActive = true
        rankLabel.sizeToFit()

    }
    
    func setupAccount() {
        
        view.addSubview(nextSubLabel)
        nextSubLabel.anchor(top: currentAccountView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        nextSubLabel.sizeToFit()
        
        view.addSubview(privacyContainer)
        view.addSubview(nextMainLabel)
        view.addSubview(lastSubLabel)
        view.addSubview(lockView)
        
        nextMainLabel.topAnchor.constraint(equalTo: privacyContainer.topAnchor, constant: 32).isActive = true
        nextMainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nextMainLabel.sizeToFit()
        
        lastSubLabel.anchor(top: nextMainLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        lastSubLabel.sizeToFit()
        
        lockView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lockView.anchor(top: lastSubLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        
        privacyContainer.anchor(top: nextSubLabel.bottomAnchor, left: view.leftAnchor, bottom: lockView.bottomAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: -32, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func setupMainButton() {
        
        view.addSubview(worksView)
        view.addSubview(container)
        
        worksView.anchor(top: privacyContainer.bottomAnchor, left: view.leftAnchor, bottom: container.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 32, paddingRight: 0, width: 0, height: 0)
        
        container.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -400, paddingRight: 0, width: 0, height: 648)
        
        view.addSubview(mainButton)
        view.addSubview(informationLabel)
        view.addSubview(mainIcon)
        
        mainButton.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 56)
        mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: cancelBottomHeight).isActive = true
        
        informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        informationLabel.anchor(top: nil, left: view.leftAnchor, bottom: mainButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 32, paddingRight: 20, width: 0, height: 0)
        informationLabel.sizeToFit()
        
        mainIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainIcon.anchor(top: nil, left: nil, bottom: informationLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 30, height: 30)
        
    }

}
