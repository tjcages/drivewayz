//
//  RecommendViewController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 9/9/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit

class RecommendViewController: UIViewController {
    
    var dynamicLink: URL?
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Discounts and rewards"
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Get more parking for less when you refer a friend to try Drivewayz."
        label.textColor = Theme.DARK_GRAY
        label.font = Fonts.SSPRegularH5
        label.numberOfLines = 10
        
        return label
    }()
    
    var inviteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLUE
        
        return view
    }()
    
    var inviteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Invite a friend", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        
        return button
    }()
    
    var moreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Learn more", for: .normal)
        button.setTitleColor(Theme.BLUE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH4
        
        return button
    }()
    
    var trophyGraphic: UIImageView = {
        let image = UIImage(named: "trophyGraphic")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        setupViews()
        prepareDynamicLink()
    }
    
    func setupViews() {
        
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(trophyGraphic)
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: trophyGraphic.leftAnchor, constant: -8).isActive = true
        subLabel.sizeToFit()
        
        trophyGraphic.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        trophyGraphic.centerYAnchor.constraint(equalTo: subLabel.centerYAnchor).isActive = true
        trophyGraphic.heightAnchor.constraint(equalToConstant: 80).isActive = true
        trophyGraphic.widthAnchor.constraint(equalTo: trophyGraphic.heightAnchor).isActive = true
        
        view.addSubview(inviteView)
        view.addSubview(inviteButton)
//        view.addSubview(moreButton)
        
        inviteButton.anchor(top: subLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 0, height: 45)
        inviteButton.sizeToFit()
        
        inviteView.anchor(top: inviteButton.topAnchor, left: view.leftAnchor, bottom: inviteButton.bottomAnchor, right: inviteButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: -20, width: 0, height: 0)
        
//        moreButton.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 20).isActive = true
//        moreButton.leftAnchor.constraint(equalTo: inviteView.rightAnchor, constant: 20).isActive = true
//        moreButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        moreButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }

}

extension RecommendViewController {
    
    func prepareDynamicLink() {
        let link = "http://bit.ly/drivewayz"
        self.dynamicLink = URL(string: link)
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "www.drivewayz.io"
//        components.path = "/invites"
//
//        let idQueryItem = URLQueryItem(name: "inviteID", value: userID)
//        components.queryItems = [idQueryItem]
//
//        guard let linkParam = components.url else { return }
//        guard let shareLink = DynamicLinkComponents.init(link: linkParam, domainURIPrefix: "https://drivewayz.page.link") else { return }
//
//        if let bundleID = Bundle.main.bundleIdentifier {
//            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
//        }
//        shareLink.iOSParameters?.appStoreID = "1397265391"
//        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
//        shareLink.socialMetaTagParameters?.title = "Drivewayz on the App Store"
//        shareLink.socialMetaTagParameters?.descriptionText = ""
//        shareLink.socialMetaTagParameters?.imageURL = URL(fileURLWithPath: "https://scontent-lax3-1.xx.fbcdn.net/v/t1.0-9/65676636_363729731000524_5831666724327391232_o.png?_nc_cat=106&_nc_oc=AQlUvN9bk_xNcoAi7HD1sCPDqIBVBP_GBaOnLw5mOb0OU9u-jbMSg_sF8mvxAH68qbM&_nc_ht=scontent-lax3-1.xx&oh=c92befcbf0204b3943b26117b6fd8315&oe=5DBB5DD4")
//
//        shareLink.shorten { (url, warnings, error) in
//            if let err = error {
//                print("Dynamic link unable to shorten", err.localizedDescription)
//            }
//            guard let url = url else { return }
//            self.dynamicLink = url
//        }
    }
    
}
